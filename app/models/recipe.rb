class Recipe < ActiveRecord::Base
  has_many :amounts
  has_many :ingredients, :through => :amounts

  has_many :personalRecipeInfo, :dependent => :destroy
  has_many :users, :through => :personalRecipeInfo

  acts_as_indexed :fields => [:name, :desc]

  mount_uploader :image, RecipePictureUploader

  validates_presence_of :name, :on => :create
  validates_uniqueness_of :url_slug, :on => :create
  validates_inclusion_of :difficulty, :in => %w(Beginner Moderate Difficult Expert)

  accepts_nested_attributes_for :ingredients
  validates_presence_of :ingredients, :on => :create, :message => 'Needs ingredients!'

  def to_param
    url_slug
  end

  def ingredients_attributes=(params)
    params.each_with_index do |(key, value), index|
      if existing_ingredient = Ingredient.find_by_name(value['name'])
        self.ingredients << existing_ingredient unless self.ingredients.include? existing_ingredient
      else
        if value['name'].empty?
          break
        end
        i = value['name'].gsub(/\b\w/){$&.upcase}
        ingredient = Ingredient.new({"name" => i})
        ingredient.save
        self.ingredients << ingredient
      end
    end
  end
end

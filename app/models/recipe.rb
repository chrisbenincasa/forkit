class Recipe < ActiveRecord::Base
  has_many :amounts
  has_many :ingredients, :through => :amounts

  has_many :personalRecipeInfo, :dependent => :destroy
  has_many :users, :through => :personalRecipeInfo

  acts_as_indexed :fields => [:name, :desc]

  mount_uploader :image, RecipePictureUploader

  validates_presence_of :name
  validates_length_of :name, :minimum => 3
  validates_uniqueness_of :url_slug
  validates_inclusion_of :difficulty, :in => %w(Beginner Moderate Difficult Expert)
  validates_presence_of :cook_time
  validates_presence_of :desc
  validates_length_of :desc, :minimum => 100
  def to_param
    url_slug
  end

=begin LEGACY
  def ingredients_attributes=(params)
    params.each_with_index do |(key, value), index|
      if existing_ingredient = Ingredient.find_by_name(value['name'])
        self.ingredients << existing_ingredient unless self.ingredients.include? existing_ingredient
        @details = self.amounts.where('ingredient_id = ' + existing_ingredient.id.to_s).first
        logger.info self.amounts.inspect
        @details['amount'] = value['amount'].to_i
        @details['units'] = value['units'] unless value['units'] == nil
        @details.save
      else
        if value['name'].empty?
          break
        end
        slug = value['name'].downcase
        ingredient = Ingredient.new({"name" => slug.gsub(/\b\w/){$&.upcase}, "url_slug" => slug.gsub(/\s/,'-')})
        ingredient.save
        self.ingredients << ingredient
      end
    end
  end
=end
end

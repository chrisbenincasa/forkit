class Recipe < ActiveRecord::Base
  has_many :amounts
  has_many :ingredients, :through => :amounts

  has_many :personalRecipeInfo
  has_many :users, :through => :personalRecipeInfo

  mount_uploader :image, RecipePictureUploader

  validates_uniqueness_of :url_slug, :on => :create
  validates_inclusion_of :difficulty, :in => %w(Beginner Moderate Difficult Expert)

  

  def to_param
    url_slug
  end
end

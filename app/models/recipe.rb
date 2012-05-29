class Recipe < ActiveRecord::Base
  has_many :amounts
  has_many :ingredients, :through => :amounts

  has_many :personalRecipeInfo
  has_many :users, :through => :personalRecipeInfo

  validates_uniqueness_of :name
  validates_inclusion_of :difficulty, :in => %w(Beginner Moderate Difficult Expert)

  def to_param
    name.parameterize
  end

end

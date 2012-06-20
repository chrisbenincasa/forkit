class Ingredient < ActiveRecord::Base
  has_many :amounts
  has_many :recipes, :through => :amounts
  acts_as_indexed :fields => [:name]

  def to_param
    name.parameterize
  end
end

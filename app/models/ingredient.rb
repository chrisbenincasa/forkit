class Ingredient < ActiveRecord::Base
  has_many :amounts
  has_many :recipes, :through => :amounts
  acts_as_indexed :fields => [:name]

  #validates_presence_of :name, :on => :create
  #validates_presence_of :url_slug, :on => :create  

  def to_param
    url_slug
  end
end
class FixRecipeServingSize < ActiveRecord::Migration
  def change
    remove_column :recipes, :serving_size
    add_column :recipes, :serving_from, :integer
    add_column :recipes, :serving_to, :integer
  end
end
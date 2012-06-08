class RecipeServingsDifficulty < ActiveRecord::Migration
  def change
    add_column :recipes, :serving_size, :string
    add_column :recipes, :difficulty, :string
  end
end

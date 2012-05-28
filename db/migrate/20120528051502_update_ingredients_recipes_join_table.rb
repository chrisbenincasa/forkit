class UpdateIngredientsRecipesJoinTable < ActiveRecord::Migration
  add_index :ingredients_recipes, [:ingredient_id, :recipe_id]
end

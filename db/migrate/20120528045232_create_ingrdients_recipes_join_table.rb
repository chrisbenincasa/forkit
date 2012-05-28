class CreateIngrdientsRecipesJoinTable < ActiveRecord::Migration
  def change
    create_table :ingredients_recipes, :id => false do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
    end
  end
end

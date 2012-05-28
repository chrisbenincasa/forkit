class Updatejoincolumns < ActiveRecord::Migration
  def change
    remove_columns :ingredients_recipes, :amount
    remove_columns :ingredients_recipes, :units
  end
end

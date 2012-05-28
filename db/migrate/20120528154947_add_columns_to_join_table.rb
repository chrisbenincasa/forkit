class AddColumnsToJoinTable < ActiveRecord::Migration
  def change
    add_column :ingredients_recipes, :amount, :integer, :null => false
    add_column :ingredients_recipes, :units, :string, :null => false
  end
end

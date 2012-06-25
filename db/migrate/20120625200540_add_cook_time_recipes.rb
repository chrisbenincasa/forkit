class AddCookTimeRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :cook_time, :string
  end
end

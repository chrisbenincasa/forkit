class EditRecipeColumn < ActiveRecord::Migration
  def change
    change_column :recipes, :desc, :text
  end
end

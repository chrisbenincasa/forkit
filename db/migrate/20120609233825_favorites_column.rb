class FavoritesColumn < ActiveRecord::Migration
  def change
    remove_column :personal_recipe_infos, :did_create
    add_column :personal_recipe_infos, :favorite, :boolean, :default => false
  end
end

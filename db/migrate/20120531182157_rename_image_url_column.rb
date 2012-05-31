class RenameImageUrlColumn < ActiveRecord::Migration
  def change
    remove_column :recipes, :image_url
    add_column :recipes, :image, :string
  end
end

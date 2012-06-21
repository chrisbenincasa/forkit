class AddSlugToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :url_slug, :string
  end
end

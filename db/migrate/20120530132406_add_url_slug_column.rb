class AddUrlSlugColumn < ActiveRecord::Migration
  def change
    add_column :recipes, :url_slug, :string, {:null => false, :default => ''}
    remove_column :recipes, :difficulty
  end
end

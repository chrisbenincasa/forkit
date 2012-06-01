class RecipeCreatedBy < ActiveRecord::Migration
  def change
    add_column :recipes, :created_by, :integer, {:null => false, :default => 1}
  end
end
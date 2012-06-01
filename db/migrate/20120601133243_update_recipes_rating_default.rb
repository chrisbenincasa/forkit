class UpdateRecipesRatingDefault < ActiveRecord::Migration
  def change
    change_column :recipes, :total_ratings, :integer, :default => 0
  end
end

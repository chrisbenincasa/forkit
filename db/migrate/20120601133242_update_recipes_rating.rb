class UpdateRecipesRating < ActiveRecord::Migration
  def change
    add_column :recipes, :total_ratings, :integer
  end
end

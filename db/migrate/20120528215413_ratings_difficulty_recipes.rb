class RatingsDifficultyRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :rating, :float, {:default => 0}
  end
end

class RatingsDifficultyRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :rating, :float, {:default => 0}
    add_column :recipes, :difficulty, "ENUM('Beginner', 'Moderate', 'Difficult', 'Expert')", {:null => false}
  end
end

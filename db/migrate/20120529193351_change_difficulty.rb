class ChangeDifficulty < ActiveRecord::Migration
  def change
    add_column :recipes, :difficulty, :string
end

class ChangeDifficulty < ActiveRecord::Migration
  def change
    change_column :recipes, :difficulty, :string
  end
end

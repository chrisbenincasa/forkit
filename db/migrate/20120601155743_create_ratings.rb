class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.integer :rating
      t.timestamps
    end
  end
end

class CreatePersonalRecipeInfos < ActiveRecord::Migration
  def change
    create_table :personal_recipe_infos do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.float :rating

      t.timestamps
    end
  end
end

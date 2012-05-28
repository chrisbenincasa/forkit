class CreateAmounts < ActiveRecord::Migration
  def change
    create_table :amounts do |t|
      t.integer :recipe_id, :null => false
      t.integer :ingredient_id, :null => false
      t.integer :amount, :null => false
      t.string :units, :null => false
      t.timestamps
    end
  end
end

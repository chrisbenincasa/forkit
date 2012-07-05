class AddIngredientsDetail < ActiveRecord::Migration
  def up
    add_column :amounts, :details, :string
  end

  def down
    remove_column :amounts, :details
  end
end

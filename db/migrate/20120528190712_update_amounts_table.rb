class UpdateAmountsTable < ActiveRecord::Migration
  def change
    remove_column :amounts, :amount
    remove_column :amounts, :units
    add_column :amounts, :amount, :integer, :null => true
    add_column :amounts, :units, :string, :null =>true
  end
end

class ChangeAmountsToFloat < ActiveRecord::Migration
  def change
    change_column :amounts, :amount, :float
  end
end

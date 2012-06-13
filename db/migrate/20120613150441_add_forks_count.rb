class AddForksCount < ActiveRecord::Migration
  def change
    add_column :recipes, :favorites, :integer, {:default => 0}
  end
end

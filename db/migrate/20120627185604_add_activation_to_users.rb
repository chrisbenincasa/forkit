class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_activated, :boolean, :default => false
  end
end

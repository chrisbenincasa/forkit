class AddTokenIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_id, :integer
    remove_column :tokens, :user_id
  end
end

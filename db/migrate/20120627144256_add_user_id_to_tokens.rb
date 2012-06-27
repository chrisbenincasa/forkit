class AddUserIdToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :user_id, :integer
  end
end

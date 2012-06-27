class ChangeTokenIdColumns < ActiveRecord::Migration
  def change
    remove_column :users, :token_id
    add_column :tokens, :user_id, :integer
  end
end
class FixUidColumn < ActiveRecord::Migration
  def change
    remove_column :authorizations, :u_id
    add_column :authorizations, :uid, :string
  end
end

class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :active_token
      t.string :reset_token
      t.timestamps
    end
  end
end

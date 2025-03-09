class AddIndexAndForeignKeyToChats < ActiveRecord::Migration[8.0]
  def change
    add_index :chats, :user_id, name: "index_chats_on_user_id"
    add_foreign_key :chats, :users, column: :user_id
  end
end

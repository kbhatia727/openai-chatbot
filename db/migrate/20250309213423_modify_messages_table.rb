class ModifyMessagesTable < ActiveRecord::Migration[8.0]
  def change
    change_column :messages, :chat_id, :integer, null: false
    add_column :messages, :content, :text
    add_column :messages, :role, :string
    add_index :messages, :chat_id, name: "index_messages_on_chat_id"
    add_foreign_key :messages, :chats
  end
end

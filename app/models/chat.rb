class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

 def message_history
    messages.order(:created_at).map do |message|
      { role: message.role, content: message.content }
    end
  end

end

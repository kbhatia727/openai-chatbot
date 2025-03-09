class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [:show, :destroy]

  def index
    @chats = current_user.chats || []

  end

  def new
    @chat = Chat.new
  end

  def show
     @messages = @chat.messages
  end

  def create
    @chat = current_user.chats.build(chat_params)
    if @chat.save
     redirect_to chat_path(@chat)
    else
     render :new
    end
  end

   def destroy
    @chat.destroy
    redirect_to chats_path
  end

  private

  def set_chat
    @chat= current_user.chats.find(params[:id])
  end
 
  def chat_params
    params.require(:chat).permit(:title)
  end

end

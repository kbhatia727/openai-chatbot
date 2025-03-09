class MessagesController < ApplicationController
	before_action :find_chat
	before_action :authenticate_user!

	def create
	    @message = @chat.messages.create(content: message_params[:content], chat: @chat, role: "user")
	    get_openai_response()
	    redirect_to chat_path(@chat)
    end

	private 
	
	def find_chat
		@chat = current_user.chats.find(params[:chat_id])
		@messages = @chat.messages
	end

    def message_params
    	params.require(:message).permit(:content)
    end

    def get_openai_response()
		begin
			client = OpenAI::Client.new

		    response = client.chat(
		    	parameters: {
		    		model: "gpt-3.5-turbo",
					messages: @chat.message_history,
					temperature: 0.8,
					stream: stream_proc
					}
				)

		rescue StandardError => e
	    
		    logger.error "Error occurred while calling OpenAI API: #{e.message}"
		    default_message = "Please try again later."
		    @chat.messages.create(content: default_message, chat: @chat, role: "assistant")
		end
    end

	def stream_proc
		assistant_message = ""
	  	proc do |chunk, _bytesize|
	  		if chunk.dig("choices",0,"finish_reason") =="stop"
	  			 logger.debug "Stream finished, saving assistant message"
	  			@chat.messages.create(content: assistant_message, chat: @chat, role: "assistant")
	  		else
	      		text= chunk.dig("choices", 0, "delta", "content")
	      		assistant_message += text unless text.nil?
	  		end
	    end
    end

end

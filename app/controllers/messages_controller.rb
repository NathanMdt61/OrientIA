class MessagesController < ApplicationController

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @challenge = @chat.challenge
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
  end

  private

  # def params

  # end

end

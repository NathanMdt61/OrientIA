class MessagesController < ApplicationController

  def create
    @chat = User.first.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  # def params

  # end

end

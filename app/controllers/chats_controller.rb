class ChatsController < ApplicationController
  def index
    @chats = Chat.all
  end

  def show
    @chat = User.first.chats.find(params[:id])
    @message = Message.new
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = User.first.chats.new
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end
end

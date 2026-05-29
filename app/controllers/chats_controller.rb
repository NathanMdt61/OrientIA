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
    @chat = User.first.chats.new(title: Chat::DEFAULT_TITLE)
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to chats_path
  end
end

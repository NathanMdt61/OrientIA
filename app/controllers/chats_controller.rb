class ChatsController < ApplicationController

  def show
    @chat = Chat.find(params[:id])
    @message = Message.new
  end

  def index
    @chats = Chat.all
  end


  def new
    @chat = Chat.new
  end

  def create
    
  end

end

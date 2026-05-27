class MessagesController < ApplicationController
  SYSTEM_PROMPT = "Tu es un conseiller d'orientation expert, Je suis un utilisateur qui a besoin d'aide pour trouver un
  métier et les études rattachées par rapport à mes hobbies, passions, études précédentes âge ect, fais des propositions
  que le texte soit aéré, fais des listes pour chaque proposition"

  def create
    @chat = User.first.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end


  private

  def instructions
    [SYSTEM_PROMPT, user_profil].compact.join("\n\n")
  end

  def user_profil
    j = User.first
    "Nom: #{j.user_name}, Âge: #{j.age} ans, Niveau scolaire: #{j.school_level}, Objectif: #{j.goal}"
  end

  def message_params
    params.require(:message).permit(:content)
  end
end

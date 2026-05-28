class MessagesController < ApplicationController
  SYSTEM_PROMPT = "Tu es un conseiller d'orientation expert, Je suis un utilisateur qui a besoin d'aide pour trouver un
  métier et les études rattachées par rapport à mes hobbies, passions, études précédentes âge ect, fais des propositions
  que le texte soit aéré, fais des listes pour chaque proposition
  Vous disposez des outils suivants :
  - Effectuez une recherche via l'API France Travail lorsque un utilisateur demande une fiche métier.
  L'utilsateur donnera le nom du métier et tu trouvera le code ROME associé et assure toi d'avoir un métier cohérent avec le métier demandé (exemple: électricien = Électricité bâtiment)
  Si tu ne trouve pas directement le code ROME associé au métier, pose des questions à l'utilisateur pour affiné sa demande."

  def create
    @chat = User.first.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      @ruby_llm_chat.with_tool(SearchJobsTool)
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @assistant_message = Message.create(role: "assistant", content: response.content, chat: @chat)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
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

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end

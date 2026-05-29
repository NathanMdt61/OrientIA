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
      @ruby_llm_chat = RubyLLM.chat
      # @ruby_llm_chat.with_tool(SearchJobsTool)
      # @ruby_llm_chat.with_tool(JobsValueTool)
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @assistant_message = Message.create(role: "assistant", content: response.content, chat: @chat)
      @chat.generate_title_from_first_message
      assistant_response = response.content
      questions_prompt = "Voici la réponse que tu viens de donner à un jeune en orientation :\n\n#{assistant_response}\n\nGénère exactement 3 questions courtes que ce jeune pourrait te poser pour en savoir plus. Réponds uniquement avec un tableau de type array valide, sans texte autour. Exemple : [\"Question 1 ?\", \"Question 2 ?\", \"Question 3 ?\"]"
      questions_response = RubyLLM.chat.ask(questions_prompt)
      @suggested_questions = JSON.parse(questions_response.content)

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
    hobbies = j.hobbies_lists.map { |hl| hl.hobbie.title }.join(", ")
    "Nom: #{j.user_name}, Âge: #{j.age} ans, Niveau scolaire: #{j.school_level}, Objectif: #{j.goal}, Hobbies: #{hobbies}"
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

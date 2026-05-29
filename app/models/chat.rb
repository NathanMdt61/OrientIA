class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  DEFAULT_TITLE = "Untitled"
  TITLE_PROMPT = <<~PROMPT
    Tu es un expert de la génération de titre, récupère la conversation et résume la en un titre en 3 à 6 mots qui
    reprend bien la thématique de la conversation, sans ponctuation
  PROMPT

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_messages = messages.order(:created_at).first(2)
    return if first_messages.empty?

    extrait = first_messages.map { |m| "#{m.role}: #{m.content}" }.join("\n")
    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(extrait)
    update(title: response.content.strip)
  end
end

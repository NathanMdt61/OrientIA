class Suggestion < ApplicationRecord
  belongs_to :job
  belongs_to :chat
end

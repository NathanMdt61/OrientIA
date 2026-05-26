class Suggestion < ApplicationRecord
  has_many :job
  belongs_to :chat
end

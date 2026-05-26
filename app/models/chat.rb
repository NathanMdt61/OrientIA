class Chat < ApplicationRecord
  belongs_to :user
  has_many :suggestions, dependent: :destroy
end

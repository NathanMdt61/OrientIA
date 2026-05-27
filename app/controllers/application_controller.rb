class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :set_chats

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes



  private

  def set_chats
    @chats = current_user.chats if user_signed_in?
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pagy::Backend

  def after_sign_in_path_for(_resource)
    stored_location_for(resource) || users_path
  end

  # def current_user
  #   User.first
  # end
end

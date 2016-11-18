class ApplicationController < ActionController::Base
	before_filter :current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_page
  	params[:page] || "1"
  end

  def per_page
  	params[:per_page] || "2"
  end

  private

  def current_user
  	@current_user = User.find_by(:auth_token => request.headers["Authorization"])
  end
end

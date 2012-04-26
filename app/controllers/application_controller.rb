class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_login
      unless logged_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to :controller => "user_sessions",:action =>"new" # halts request cycle
      end
    end

    def logged_in?
      !!current_user
    end

end

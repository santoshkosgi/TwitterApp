class AuthorizationsController < ApplicationController
   before_filter :require_login, :only => [:destroy]

  def create
    omniauth = request.env['omniauth.auth'] #this is where you get all the data from your provider through omniauth
    @auth = Authorization.find_from_hash(omniauth)
    if current_user
      flash[:notice] = "Successfully added #{omniauth['provider']} authentication"
      current_user.authorizations.create(:provider => omniauth['provider'], :uid => omniauth['uid']) #Add an auth to existing user
    elsif @auth
      flash[:notice] = "Welcome back #{omniauth['provider']} user"
      #create session
      UserSession.create(@auth.user, true) # if you are using authlogic, this will create the session
      consumer = OAuth::Consumer.new("mshsD0jpgcYwwOEcTW5ZTA", "V6KTqllY5jS392pj4FNFCb5EiOM8DaFzVwr9cS54XQ", { :site => "https://api.twitter.com", :request_token_path => '/oauth/request_token', :access_token_path => '/oauth/access_token', :authorize_path => '/oauth/authorize', :scheme => :header })
      access_token = OAuth::AccessToken.new(consumer,omniauth['credentials']['token'],omniauth['credentials']['secret'])
      msg = {'status' => 'Hey look I can tweet via OAuth!'}
      response = access_token.post('https://api.twitter.com/1/statuses/update.json', msg, { 'Accept' => 'application/xml' })
      puts response
      #User is present. Login the user with his social account
    else
      @new_auth = Authorization.create_from_hash(omniauth, current_user) #Create a new user
      flash[:notice] = "Welcome #{omniauth['provider']} user. Your account has been created."
      #create session
      UserSession.create(@new_auth.user, true) # if you are using authlogic, this will create the session
    end
    redirect_to root_url
  end

  def failure
    flash[:notice] = "Sorry, You din't authorize"
    redirect_to root_url
  end

  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    redirect_to profile_path(current_user.username)
  end
end

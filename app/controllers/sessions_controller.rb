class SessionsController < ApplicationController
  def new
  end

  def create
    # pulls the user out of the database using the submitted email address
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user
    else
      message = "account not activated "
      message += "check your email for the activation link"
      flash[:warning] = message
      redirect_to root_url
    end
  else
      flash.now[:danger] = "Invalid email/password combination"
    render 'new', status: :unprocessable_entity
  end
end

  def destroy
    # calling log_out only if logged_in? is true
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end

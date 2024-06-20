module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user 
        if session[:user_id]
            # if @current_user is not already set (it's nil or false), then find the User with the id stored in session[:user_id] and assign that User object to @current_user. If @current_user is already set, then do nothing
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    def logged_in?
        !current_user.nil?
    end

    def log_out
        reset_session
        @current_user = nil
    end
end

module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
        # guard agains session replay attacks
        session[:session_token] = user.session_token
    end

    # remembers a user in a persistent session
    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

     # returns the user corresponding to the remember token cookie
    def current_user 
        if (user_id = session[:user_id])
            user = User.find_by(id: user_id)
            if user && session[:session_token] == user.session_token
                @current_user = user
            end
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user 
                @current_user = user
            end
        end
    end

    # returns true if the given user is the current user
    def current_user?(user)
        user && user == current_user
    end

    # returns true if the user is logged in, false otherwise
    def logged_in?
        !current_user.nil?
    end

    # forgets a persistent session
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # logs out the current user
    def log_out
        forget(current_user)
        reset_session
        @current_user = nil
    end

    # storing the location of the requested page but only for a get request
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
end

module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
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
            # If @current_user is already set, the code does nothing. If @current_user is nil or false, it assigns to @current_user the result of User.find_by(id: user_id). This attempts to find a user in the database with the specified user_id. If a user with this ID exists, the user object is assigned to @current_user; if no such user exists, nil is assigned to @current_user.
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user 
                @current_user = user
            end
        end
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
end

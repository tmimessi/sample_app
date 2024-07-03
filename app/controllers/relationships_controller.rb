class RelationshipsController < ApplicationController
    before_action :logged_in_user

    def create
        @user = User.find(params[:followed_id])
        current_user.follow(@user)
        # using 'turbo' to update only the follow/unfollow button and the followet count while leaving the rest of the page alone
        # in this code, only one of the lines get executed, working like an if-elsif
        respond_to do |format| 
            format.html { redirect_to @user }
            format.turbo_stream
        end
    end

    def destroy
        @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |format|
            format.html { redirect_to @user, status: :see_other }
            format.turbo_stream
        end
    end
end

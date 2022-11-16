class SessionsController < ApplicationController
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
        if @user
            login(@user)
            redirect_to user_url(@user)
        else
            render :new
        end
    end

    def destroy
        if current_user.session_token == session[:session_token]
            current_user.reset_session_token!
        end
        session[:session_token] = nil 
        render :new
    end
end
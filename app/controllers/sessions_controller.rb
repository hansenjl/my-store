class SessionsController < ApplicationController

    def new
    end

    def create
        @user = User.find_by(username: params[:user][:username])
        if @user.authenticate(params[:user][:password])
            session[:user_id] = @user.id
            redirect_to user_path(@user)
        else
            flash[:notice] = 'Log in failed. Please try again.'
            render :new
        end
    end

    def destroy
        session.delete :user_id
        redirect_to root_path
    end
end

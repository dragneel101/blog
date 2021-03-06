class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :edit, :destroy]
    before_action :require_user, only: [:edit, :update, :destroy]
    before_action :require_same_user,only: [:edit,:update, :destroy]



    def new
        @user = User.new

    end

    def edit        
    end

    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 6)
    end

    def index
        @users = User.paginate(page: params[:page], per_page: 6)
    end

    def update
        if @user.update(user_params)
            flash[:notice] = "your profile has been updated"
            redirect_to @user
        else
            render 'edit'
        end
    end
    
    def create 
        @user = User.new(user_params)
        if @user.save
            session[:user_id]=@user.id
            flash[:notice] = "Welcome to the Tech Blog #{@user.username} you have successfully signed up"
            redirect_to articles_path
        else
            render 'new'
        end
    end

    def destroy
        @user.destroy
        
        if !current_user.admin?
            session[:user_id] = nil
            flash[:notice] = "Account and all associated articles has been successfully deleted"
            redirect_to articles_path  
        else
            flash[:notice] = "Account and all associated articles has been successfully deleted"
            redirect_to users_path
        end
                  

    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
    def set_user
        @user = User.find(params[:id])

    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "you do not have authorization"
            redirect_to @user
        end
    end
           
    
end

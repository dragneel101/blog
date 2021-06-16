class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :edit]

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

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
    def set_user
        @user = User.find(params[:id])

    end
        
    
end

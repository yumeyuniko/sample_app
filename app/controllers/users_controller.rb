class UsersController < ApplicationController
 before_action :logged_in_user, only: [:index,:edit, :update, :destroy]  
 before_action :correct_user,   only: [:edit, :update]
 before_action :admin_user,     only: :destroy
 
 
 #GET /users
  def index
    @users = User.paginate(page: params[:page])
  end
  
  #GET /users/:id
  def show
    @user = User.find(params[:id])
  end
  
  #GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users (+ params)
  def create
      #(@user + given params).save
      # User.create(params[:user])
      # User.create(params[:user])
     @user =  User.new(user_params) 
     if @user.save
       #Success(valid params)
       #GET "/users/#{@user.id}"
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
       #redirect_to user_path(@user)
       #redirect_to user_path(@user.id)
       #redirect_to user_path(1)
       #            => /users/1
     else
       #faliure(not validv params)
       render 'new'
     end  
  end
  
  #GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    # => app/views/users/edit.html.erb
  end
  
  
  #PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end  
  
  
  #DELETEリクエストが /users/:idに来たときにdestroyアクションが反応する
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    
    # ログイン済みユーザーかどうか確認
    def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
    end
    
    
       # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user 
    end
    
        # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

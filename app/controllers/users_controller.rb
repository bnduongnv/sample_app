class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:edit, :show, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate page: params[:page],
                           per_page: Settings.total_user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".title_sample"
      redirect_to @user
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "update_mesage"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    flash[:success] = if @user.destroy
                        t "delete_mesage_success"
                      else
                        t "delete_mesage_failed"
                      end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "login_mesage"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_path unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end
end

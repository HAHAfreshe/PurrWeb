class ColumnsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @columns = @user.columns.all

    render json: @columns
  end

  def show
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:id])

    render :show
  end

  def create
    @user = User.find(params[:user_id])
    @column = @user.columns.create(column_params)
    if @column.save
      render :show
    else
      render json: {
        success: false,
        error: "Can't create column!"
      }, status: :bad_request
    end
  end

  def update
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:id])
    if @column.update(column_params)
      render :show
    else
      render json: {
        success: false,
        error: "Can't update column!"
      }, status: :bad_request
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:id])
    if @column.destroy
      head(:ok)
    else
      head(:bad_request)
    end
  end

  private

  def column_params
    params.permit(:title, :description)
  end
end

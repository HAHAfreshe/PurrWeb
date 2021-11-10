class CardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:column_id])
    @cards = @column.cards.all

    render json: @cards
  end

  def show
    @card = Card.find(params[:id])
    @column = Column.find(@card.column_id)
    @user = User.find(@column.user_id)

    render :show
  end

  def create
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:column_id])
    @card = @column.cards.create(card_params)
    if @card.save
      render :show
    else
      render json: {
        success: false,
        error: "Can't create card!"
      }, status: :bad_request
    end
  end

  def update
    @card = Card.find(params[:id])
    @column = Column.find(@card.column_id)
    @user = User.find(@column.user_id)

    if @card.update(card_params)
      render :show
    else
      render json: {
        success: false,
        error: "Can't update card!"
      }, status: :bad_request
    end
  end

  def destroy
    @card = Card.find(params[:id])
    @column = Column.find(@card.column_id)
    @user = User.find(@column.user_id)

    if @card.destroy
      head(:ok)
    else
      head(:bad_request)
    end
  end

  private

  def card_params
    params.permit(:title, :description)
  end
end

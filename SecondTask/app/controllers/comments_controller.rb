class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:column_id])
    @card = @column.cards.find(params[:card_id])
    @comments = @card.comments.all

    render json: @comments
  end

  def show
    @comment = Comment.find(params[:id])
    @card = Card.find(@comment.card_id)
    @column = Column.find(@card.column_id)
    @user = User.find(@column.user_id)

    render :show
  end

  def create
    @user = User.find(params[:user_id])
    @column = @user.columns.find(params[:column_id])
    @card = @column.cards.find(params[:card_id])
    @comment = @card.comments.create(comment_params)

    if @comment.save
      render :show
    else
      render json: {
        success: false,
        error: "Can't create comment!"
      }, status: :bad_request
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @card = Card.find(@comment.card_id)
    @column = Column.find(@card.column_id)
    @user = User.find(@column.user_id)

    if @comment.update(comment_params)
      render :show
    else
      render json: {
        success: false,
        error: "Can't update comment!"
      }, status: :bad_request
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @card = Card.find(@comment.card_id)
    @column = Column.find(@card.column_id)
    @user = User.find(@column.user_id)

    if @comment.destroy
      head(:ok)
    else
      head(:bad_request)
    end
  end

  private

  def comment_params
    params.permit(:commenter, :body)
  end
end

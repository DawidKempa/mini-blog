class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'Komentarz został dodany.'
    else
      render 'posts/show'
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    authorize_comment
    @comment.destroy
    redirect_to post_path(@post), notice: 'Komentarz został usunięty.'
  end

  def edit
    @comment = @post.comments.find(params[:id])
    authorize_comment
  end

  def update
    @comment = @post.comments.find(params[:id])
    authorize_comment

    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Komentarz został zaktualizowany.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_comment
    unless current_user.admin? || @comment.user == current_user
      redirect_to root_path, alert: 'Nie masz uprawnień do tej akcji.'
    end
  end
end

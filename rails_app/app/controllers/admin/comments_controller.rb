class Admin::CommentsController < Admin::BaseController
  before_action :set_post, only: [:create]

  def index
    @comments = Comment.includes(:user, :post)
                      .order(created_at: :desc)
                      .page(params[:page]).per(12)
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to admin_post_path(@post), notice: 'Komentarz został dodany.'
    else
      @comment = @post.comments.build(comment_params) unless @comment
      render 'admin/posts/show', status: :unprocessable_entity
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_post_path(@comment.post), notice: 'Komentarz został usunięty'
  end

  def edit
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to admin_comments_path, notice: 'Komentarz został zaktualizowany.'
    else
      @post = @comment.post
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
end

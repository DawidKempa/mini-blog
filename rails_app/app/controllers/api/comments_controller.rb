module Api
  class CommentsController < Admin::BaseController
    before_action :set_post, only: [:create]
    before_action :set_comment, only: [:destroy, :update]

    def index
      @comments = Comment.includes(:user, :post)
                         .order(created_at: :desc)
                         .page(params[:page]).per(12)

      render json: @comments.as_json(include: {
        user: { only: [:id, :name, :email] },
        post: { only: [:id, :title] }
      })
    end

    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user

      if @comment.save
        render json: @comment.as_json(include: {
          user: { only: [:id, :name, :email] },
          post: { only: [:id, :title] }
        }), status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @comment.update(comment_params)
        render json: @comment.as_json(include: {
          user: { only: [:id, :name, :email] },
          post: { only: [:id, :title] }
        }), status: :ok
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      if @comment.destroy
        render json: { message: 'Komentarz został usunięty.' }, status: :ok
      else
        render json: { errors: 'Nie udało się usunąć komentarza.' }, status: :unprocessable_entity
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
  end
end

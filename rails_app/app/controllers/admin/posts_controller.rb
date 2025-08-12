module Admin
  class PostsController < Admin::BaseController
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def index
      @posts = Post.order(created_at: :desc).page(params[:page]).per(12)
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params.merge(user: current_user))
      if @post.save
        redirect_to admin_posts_path, notice: "Post został dodany!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: "Post zaktualizowany!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: 'Post został pomyślnie usunięty.'
    end

    def show
      @post = Post.find(params[:id])
      @comment = @post.comments.build
      
    end

    private

    def set_post
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_posts_path, alert: 'Post nie został znaleziony'
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
  end
end
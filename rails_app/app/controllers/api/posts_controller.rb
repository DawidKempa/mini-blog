module Api
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
    skip_before_action :authenticate_user!

    def index
      posts = Post.all.order(created_at: :desc)
      render json: posts.map { |post| format_post(post) }
    end

    def show
      render json: format_post(@post)
    end

    def create
      post = Post.new(post_params)
      if post.save
        render json: format_post(post), status: :created
      else
        render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @post.update(post_params)
        render json: format_post(@post)
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      head :no_content
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def format_post(post)
      {
        id: post.id,
        title: post.title,
        body: post.body,
        created_at: post.created_at,
        updated_at: post.updated_at,
        user_id: post.user_id,
        user_email: post.user&.email
      }
    end
  end
end

module Api
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, only: [:show]
    skip_before_action :authenticate_user!

    def index 
      comments = Comment.includes(:user,:post)
                      .order(created_at: :desc)
      render json: comments.map { |comment| format_commnent(comment)}               
    end

    def show
      render json: format_comment(@comment)
    end

    def create
      comment = Comment.new(comment_params)
      comment.user = current_user

      if comment.save
        render json: format_comment(comment), status: :created
      else
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def format_commnent(comment)
      {
        id: comment.id,
        content: comment.content,
        created_at: comment.created_at,
        updated_at: comment.updated_at,
        post:{
          id: comment.post.id,
          title: comment.post.title,
        },
        user: {
          id: comment.user.id,
          email: comment.user.email
        }
      }
    end
  end
end

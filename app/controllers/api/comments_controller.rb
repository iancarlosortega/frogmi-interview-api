module Api
  class CommentsController < ApplicationController
    def create
      comment = Comment.new(comment_params)

      if comment.save
        render json: comment, status: :created
      else
        render json: { error: comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.permit(:feature_id, :body)
    end
  end
end

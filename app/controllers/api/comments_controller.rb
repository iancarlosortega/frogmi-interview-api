module Api
  class CommentsController < ApplicationController

    MAX_PER_PAGE = 100

    def index

      # Validations
      return render(validate_per_page_param) if validate_per_page_param

      comments = Comment.where(feature_id: params[:feature_id]).order(created_at: :desc)

      total_count = comments.count
      comments = comments.paginate(page: params[:page], per_page: params[:per_page])

      render json: {
        data: comments,
        pagination: {
          current_page: comments.current_page,
          total: total_count,
          per_page: comments.per_page
        }
      }

    end

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

    def validate_per_page_param

      per_page = params[:per_page]&.to_i

      if per_page.present? && (per_page < 1 || per_page > MAX_PER_PAGE)
        return { json: { error: "per_page param must be between: 1 and #{MAX_PER_PAGE}" }, status: :bad_request }
      end

      return false
    end
  end
end

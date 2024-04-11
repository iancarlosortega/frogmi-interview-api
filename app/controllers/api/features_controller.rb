
module Api
  class FeaturesController < ApplicationController

    MAX_PER_PAGE = 1000
    ALLOWED_MAG_TYPES = %w(md ml ms mw me mi mb mlg)

    def index

      # Validations
      return render(validate_per_page_param) if validate_per_page_param
      return render(validate_mag_type_param) if validate_mag_type_param
      return render(validate_mag_types_filter_param) if validate_mag_types_filter_param

      features = Feature.all

      if params[:filters].present? && params[:filters][:mag_type].is_a?(Array)
        features = features.where(mag_type: params[:filters][:mag_type])
      elsif params[:mag_type].present?
        features = features.where(mag_type: params[:mag_type])
      end

      total_count = features.count
      features = features.paginate(page: params[:page], per_page: params[:per_page])

      render json: {
        data: features.map { |feature| feature_as_json(feature) },
        pagination: {
          current_page: features.current_page,
          total: total_count,
          per_page: features.per_page
        }
      }
    end

    def show
      feature = Feature.find(params[:id])
      render json: feature_as_json(feature)
      rescue ActiveRecord::RecordNotFound
      render json: { error: 'Feature not found' }, status: :not_found
    end

    private

    def validate_per_page_param

      per_page = params[:per_page]&.to_i

      if per_page.present? && (per_page < 1 || per_page > MAX_PER_PAGE)
        return { json: { error: "per_page param must be between: 1 and #{MAX_PER_PAGE}" }, status: :bad_request }
      end

      return false
    end

    def validate_mag_type_param

      mag_type = params[:mag_type]

      if mag_type.present? && !ALLOWED_MAG_TYPES.include?(mag_type)
        return { json: { error: "mag_type param must be one of: #{ALLOWED_MAG_TYPES.join(', ')}" }, status: :bad_request }
      end
    
      return false
    end

    def validate_mag_types_filter_param
      if params[:filters].present? && params[:filters][:mag_type].is_a?(Array)
        invalid_mag_types = params[:filters][:mag_type] - ALLOWED_MAG_TYPES
        if invalid_mag_types.present?
          return { json: { error: "Invalid mag_type values: [#{invalid_mag_types.join(', ')}], allowed mag_type values are: [ #{ ALLOWED_MAG_TYPES.join(', ') }]" }, status: :bad_request }
        end
      end

      return false
    end

    def feature_as_json(feature)
      {
        id: feature.id,
        type: feature.type,
        attributes: {
          external_id: feature.external_id,
          magnitude: feature.magnitude,
          place: feature.place,
          time: feature.time,
          tsunami: feature.tsunami,
          mag_type: feature.mag_type,
          title: feature.title,
          coordinates: {
            longitude: feature.longitude,
            latitude: feature.latitude
          }
        },
        links: {
          external_url: feature.external_url
        }
      }
    end
  end
end

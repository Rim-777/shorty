module Api
  module V1
    class Links < Grape::API
      version 'v1'
      format :json
      content_type :json, 'application/json'

      rescue_from ActiveRecord::RecordNotFound do
        error!('The shortcode cannot be found in the system', 404)
      end

      rescue_from ActiveRecord::RecordInvalid do |error|
        code = case error
                 when Link::DuplicateError
                   409
                 when Link::FormatError
                   422
                 else
                   400
               end

        error!(error.message, code)
      end

      post :shorten do
        {shortcode: Link.create!(url: params[:url], shortcode: params[:shortcode]).try(:shortcode)}
      end

      resource :shortcode do
        get do
          link = Link.find_by_shortcode!(params[:shortcode])
          link.increment_redirect_count!
          header('Location', link.url); status(302)
        end

        get :stats do
          Link.find_by_shortcode!(params[:shortcode]).try(:stats)
        end
      end
    end
  end
end

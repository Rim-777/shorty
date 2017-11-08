module Api
  module V1
    class Links < Grape::API
      version 'v1'
      format :json
      content_type :json, 'application/json'
      prefix :api

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

      params do
        requires :url, type: String, desc: 'url for shorten'
        optional :shortcode, type: String, desc: 'desirable shortcode for shorten'
      end

      desc 'Shortens some url and returns some shortcode'
      post :shorten do
        {shortcode: Link.create!(url: params[:url], shortcode: params[:shortcode]).shortcode}
      end

      resource :shortcode do
        params {requires :shortcode, type: String, desc: 'shortcode for the redirect'}

        desc 'Gets some shortcode and returns the location the redirect'
        get do
          link = Link.find_by_shortcode!(params[:shortcode])
          link.increment_redirect_count!
          header('Location', link.url); status(302)
        end

        params {requires :shortcode, type: String, desc: 'shortcode to get metadata'}

        desc "Gets a shortcode and returns url's meta data"
        get :stats do
          Link.find_by_shortcode!(params[:shortcode]).stats
        end
      end

      add_swagger_documentation(
          api_version: 'v1',
          hide_documentation_path: true,
          info: {
              title: 'Cute-urls',
              description: 'Simple solution to shorten links'
          }
      )
    end
  end
end

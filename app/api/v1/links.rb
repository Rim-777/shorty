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

      desc 'Shortens some url and returns some shortcode'
      post :shorten do
        {shortcode: Link.create!(url: params[:url], shortcode: params[:shortcode]).shortcode}
      end

      desc 'Gets some shortcode and returns the location for redirect'
      resource :shortcode do
        get do
          link = Link.find_by_shortcode!(params[:shortcode])
          link.increment_redirect_count!
          header('Location', link.url); status(302)
        end

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
              description: 'simple solution to shorten links'
          }
      )
    end
  end
end

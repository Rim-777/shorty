module Api
  module V1
    class Links < Grape::API
      version 'v1'
      format :json
      content_type :json, 'application/json'

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
    end
  end
end

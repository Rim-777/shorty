module Messageable
  extend ActiveSupport::Concern
  included do

    def format_error_message
     'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'
    end

    def duplicate_error_message
      'The the desired shortcode is already in use'
    end
  end
end
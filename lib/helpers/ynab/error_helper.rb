# frozen_string_literal: true

module Helpers
  module YNAB
    module ErrorHelper
      def self.build_error_message(error, entries)
        <<~ERROR_MESSAGE
          ERROR:
          id=#{error.id}
          name=#{error.name}
          detail: #{error.detail}
          data: #{entries}
        ERROR_MESSAGE
      end
    end
  end
end

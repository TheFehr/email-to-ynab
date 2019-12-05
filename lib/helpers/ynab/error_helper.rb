# frozen_string_literal: true

module Helpers
  module YNAB
    module ErrorHelper
      def build_error_message(error, entries)
        'ERROR:'\
        "id=#{error.id}"\
        "name=#{error.name}"\
        "detail: #{error.detail}"\
        "data: #{entries}"
      end
    end
  end
end
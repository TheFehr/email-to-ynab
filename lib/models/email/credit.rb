# frozen_string_literal: true

require_relative 'entry'

module Models
  module EMail
    class Credit < Entry
      def real_amount
        @amount
      end
    end
  end
end

# frozen_string_literal: true

module Models
  module EMail
    class Debit < Entry
      def real_amount
        @amount * -1
      end
    end
  end
end

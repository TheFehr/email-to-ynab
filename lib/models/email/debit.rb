# frozen_string_literal: true

module Models
  module EMail
    class Debit < Entry
      def real_amount
        (@amount * -1000).to_i
      end
    end
  end
end

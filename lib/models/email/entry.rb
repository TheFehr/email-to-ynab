# frozen_string_literal: true

module Models
  module EMail
    class Entry
      include ActiveModel::Model

      attr_accessor :uid, :account, :amount, :charge_date, :value_date,
                    :memo, :real_amount, :payee_name, :payee_id
      delegate :account, :amount, :charge_date, :value_date,
               :memo, :real_amount, :payee_name, :payee_id, to: :@content

      def initialize(data)
        @uid = data[:uid]
        @content = Content.new data
      end
    end
  end
end

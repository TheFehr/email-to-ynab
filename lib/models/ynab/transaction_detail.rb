# frozen_string_literal: true

module Models
  module YNAB
    class TransactionDetail
      include ActiveModel::Model

      attr_accessor :date, :amount, :memo

      validates :amount, :date, presence: true

      def initialize(data)
        @date = data[:date]
        @amount = data[:amount]
        @memo = data[:memo]
      end
    end
  end
end

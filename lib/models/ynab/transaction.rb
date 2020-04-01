# frozen_string_literal: true

require 'active_model'
require 'active_support/core_ext/date_time'

module Models
  module YNAB
    class Transaction
      DEFAULT_FLAG_COLOR = 'Blue'

      include ActiveModel::Model

      attr_accessor :account_id, :detail, :payee

      validates :account_id, :detail, :payee, presence: true

      def initialize(data)
        @account_id = data[:account_id]
        @detail = TransactionDetail.new(data)
        @payee = Payee.new(data)
      end

      def to_h
        {
          account_id: @account_id,
          date: @detail.date.strftime('%Y-%m-%d'),
          payee_name: @payee.name,
          payee_id: @payee.id,
          memo: @detail.memo,
          cleared: 'cleared',
          approved: true,
          flag_color: DEFAULT_FLAG_COLOR,
          amount: @detail.amount
        }.reject { |_key, value| value.nil? }
      end
    end
  end
end

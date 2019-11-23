# frozen_string_literal: true

require 'active_model'
require 'active_support/core_ext/date_time'

module Models
  module YNAB
    class Transaction
      DEFAULT_FLAG_COLOR = 'Blue'

      include ActiveModel::Model

      attr_accessor :account_id, :date, :payee_name, :payee_id, :memo

      validates :account_id, :date, :amount, presence: true
      validate :payee_info?

      def initialize(account_id, date, payee_name, payee_id, amount, memo)
        @account_id = account_id
        @date = date
        @payee_name = payee_name
        @payee_id = payee_id
        @amount = amount
        @memo = memo
      end

      def to_h
        {
          account_id: @account_id,
          date: @date.strftime('%Y-%m-%d'),
          payee_name: @payee_name,
          payee_id: @payee_id,
          memo: @memo,
          cleared: 'cleared',
          approved: true,
          flag_color: DEFAULT_FLAG_COLOR,
          amount: @amount
        }.reject { |_, value| value.nil? }
      end

      private

      def payee_info?
        @payee_name.present? || @payee_id.present?
      end
    end
  end
end

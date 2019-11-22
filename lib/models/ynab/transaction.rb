# frozen_string_literal: true

require 'active_model'
require 'active_support/core_ext/date_time'

module Models
  module YNAB
    class Transaction
      include ActiveModel::Model

      validates :account_id, :date, :amount, presence: true
      validate :payee_info?

      def initialize(account_id, date, payee_name, payee_id, **options)
        @account_id = account_id
        @date = DateTime.parse(date)
        @payee_name = payee_name
        @payee_id = payee_id
        @memo = options[:memo]
        @cleared = options[:cleared]
        @approved = options[:approved]
        @flag_color = options[:flag_color]
        @amount = format_amount(options[:amount], options[:entry_type])
      end

      def to_h
        {
          account_id: @account_id,
          date: @date.to_formatted_s('%Y-%m-%d'),
          payee_name: @payee_name,
          payee_id: @payee_id,
          memo: @memo,
          cleared: @cleared,
          approved: @approved,
          flag_color: @flag_color,
          amount: @amount
        }.reject { |_, value| value.nil? }
      end

      private

      def payee_info?
        @payee_name.present? || @payee_id.present?
      end

      def format_amount(amount, entry_type)
        (amount.to_d * 1000).to_i * (entry_type == 'Belastung' ? -1 : 1)
      end
    end
  end
end

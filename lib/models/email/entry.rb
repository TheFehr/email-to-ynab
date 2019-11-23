# frozen_string_literal: true

require 'validates_type'

module Models
  module EMail
    class Entry
      include ActiveModel::Model

      attr_accessor :uid, :account, :amount, :charge_date, :value_date, :memo, :payee_id, :payee_name

      validates_presence_of :account, :amount, :charge_date, :value_date, :memo
      validates_numericality_of :amount
      validates_type :charge_date, :date, allow_blank: false
      validates_type :value_date, :date, allow_blank: false
      validates_type :account, :string, allow_blank: false

      def initialize(uid, account, amount, charge_date, memo, value_date)
        @uid = uid
        @account = account
        @amount = amount.gsub('\'', '').to_f
        @charge_date = Date.parse charge_date
        @value_date = Date.parse value_date
        @memo = memo

        correct_value_date
      end

      def real_amount
        (amount * 1000).to_i
      end

      private

      def correct_value_date
        correct_date = Helpers::EMail::ContentParser.find_date_in_memo(@memo)
        @value_date = Date.parse correct_date if correct_date.present?
      end
    end
  end
end

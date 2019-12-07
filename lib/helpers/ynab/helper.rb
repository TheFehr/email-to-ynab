# frozen_string_literal: true

require_relative '../../models/ynab/transaction'
require 'active_support/core_ext/date_time'

module Helpers
  module YNAB
    class Helper
      class << self
        def build_transactions(matched_data)
          matched_data.map do |email_entry|
            if email_entry.valid?
              build_entry(email_entry)
            else
              notify_missing_info(email_entry)
              next
            end
          end.reject(&:nil?)
        end

        def post_entries(ynab_entries)
          API::YNAB.instance.post_entries(ynab_entries)
        end

        private

        def build_entry(email_data)
          Models::YNAB::Transaction.new(
            account_id: email_data.account,
            date: email_data.value_date,
            payee_name: email_data.payee_name,
            payee_id: email_data.payee_id,
            amount: email_data.real_amount,
            memo: email_data.memo
          )
        end

        def notify_missing_info(entry)
          entry.validate

          Helpers::Pushbullet::Helper.send_info("#{entry.uid}:\n#{entry.errors.full_messages.join(' ')}")
        end
      end
    end
  end
end

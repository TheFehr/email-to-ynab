# frozen_string_literal: true

require_relative '../../models/ynab/transaction'
require 'active_support/core_ext/date_time'

class YNABHelper
  ACCOUNTS = {
    'Jugendkonto YoungMemberPlus "Jugendkonto"': '08616d21-266a-4f82-8c57-e1e6244694bb'
  }.freeze

  def initialize(access_token)
    @api = YNAB::API.new(access_token)
    @pushbullet = PushbulletHelper.new
  end

  def build_entries(matched_data)
    matched_data.map do |data|
      notify_missing_info unless has_required? data

      Transaction.new(
        ACCOUNTS[data[:account].to_sym],
        data[:valuta_date],
        data[:payee_name],
        data[:payee_id],
        memo: data[:memo], cleared: data[:cleared], approved: data[:approved],
        flag_color: data[:flag_color], amount: data[:amount], entry_type: data[:entry_type]
      )
    end
  end

  def post_entries(ynab_entries, mail_helper)
    @api.transactions.create_transaction(ENV['YNAB_BUDGET_ID'], transactions: ynab_entries.map(&:to_h))
    mail_helper.set_emails_to_flagged
  rescue YNAB::ApiError => e
    puts "ERROR: id=#{e.id}; name=#{e.name}; detail: #{e.detail}"
  end
end

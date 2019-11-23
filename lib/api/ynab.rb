# frozen_string_literal: true

require 'ynab'

module API
  class YNAB
    def initialize(access_token)
      @api = ::YNAB::API.new(access_token)
    end

    def post_entries(ynab_entries)
      @api.transactions.create_transaction(ENV['YNAB_BUDGET_ID'], transactions: ynab_entries.map(&:to_h))
      ::Helpers::EMail::Inbox.set_emails_to_flagged
    rescue ::YNAB::ApiError => e
      puts "ERROR: id=#{e.id}; name=#{e.name}; detail: #{e.detail}"
      ::Helpers::Pushbullet::Helper.send_info("ERROR:\nid=#{e.id}\nname=#{e.name}\ndetail: #{e.detail}\ndata: #{ynab_entries}")
    end
  end
end

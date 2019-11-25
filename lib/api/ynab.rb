# frozen_string_literal: true

require 'ynab'

module API
  class YNAB
    def initialize
      @api = ::YNAB::API.new(Helpers::Config::Loader.new.ynab[:api_key])
    end

    def post_entries(ynab_entries)
      @api.transactions.create_transaction(Helpers::Config::Loader.new.ynab[:budget_id], transactions: ynab_entries.map(&:to_h))
      ::Helpers::EMail::Mailbox.set_emails_to_flagged
    rescue ::YNAB::ApiError => e
      puts "ERROR: id=#{e.id}; name=#{e.name}; detail: #{e.detail}"
      ::Helpers::Pushbullet::Helper.send_info("ERROR:\nid=#{e.id}\nname=#{e.name}\ndetail: #{e.detail}\ndata: #{ynab_entries}")
    end
  end
end

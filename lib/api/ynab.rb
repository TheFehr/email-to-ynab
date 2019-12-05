# frozen_string_literal: true

require 'ynab'

module API
  class YNAB
    include Singleton

    def initialize
      @configs = Helpers::Config::Loader.instance.ynab
      @api = ::YNAB::API.new(@configs[:api_key])
    end

    def post_entries(ynab_entries)
      @api.transactions
          .create_transaction(@configs[:budget_id], transactions: ynab_entries.map(&:to_h))
      ::Helpers::EMail::Mailbox.set_emails_to_flagged
    rescue ::YNAB::ApiError => e
      error_message = build_error_message(e, ynab_entries)
      puts error_message
      ::Helpers::Pushbullet::Helper.send_info(error_message)
    end
  end
end

# frozen_string_literal: true

module API
  class YNAB
    def initialize(access_token)
      @api = YNAB::API.new(access_token)
      @pushbullet = PushbulletHelper.new
    end

    def post_entries(ynab_entries, mail_helper)
      @api.transactions.create_transaction(ENV['YNAB_BUDGET_ID'], transactions: ynab_entries.map(&:to_h))
      mail_helper.set_emails_to_flagged
    rescue YNAB::ApiError => e
      puts "ERROR: id=#{e.id}; name=#{e.name}; detail: #{e.detail}"
    end
  end
end

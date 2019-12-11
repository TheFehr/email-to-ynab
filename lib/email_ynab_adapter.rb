# frozen_string_literal: true

class EMailYNABAdapter
  def self.run
    @config_helper = Helpers::Config::Loader.instance.validate!

    unread_mail_bodies = Helpers::EMail::Mailbox.load_unparsed_emails
    puts "#{unread_mail_bodies.size} EMAILS FOUND, PARSING..." if unread_mail_bodies
    mail_entries = Helpers::EMail::ContentParser.parse_bodies(unread_mail_bodies)
    if mail_entries.nil?
      no_emails
    else
      emails(mail_entries)
    end
  rescue ::JSON::Schema::ValidationError => e
    puts "CONFIG-ERROR:\n#{e.message}"
  end

  def self.no_emails
    puts '0 UNFLAGGED EMAILS'
  end

  def self.emails(mail_entries)
    transactions = Helpers::YNAB::Helper.build_transactions(mail_entries)
    pp transactions.map(&:to_h) if ARGV.include?('debug')
    if ARGV.include?('push') && !transactions.empty?
      puts "#{transactions.size} ENTRIES ARE BEING CREATED"
      Helpers::YNAB::Helper.post_entries(transactions)
    else
      puts "#{transactions.size} ENTRIES READY TO PUSH"
    end
  end
end

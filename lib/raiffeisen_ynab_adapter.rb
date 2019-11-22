# frozen_string_literal: true

require_relative 'helpers/email/inbox'
require_relative 'helpers/email/content_parser'

class RaiffeisenYNABAdapter
  def self.run
    Helpers::Config::ConfigHelper.validate!

    unread_mail_bodies = Helpers::EMail::Inbox.load_unparsed_emails('Raiffeisen')
    puts "#{unread_mail_bodies.size} EMAILS FOUND, PARSING..." if unread_mail_bodies
    mail_entries = Helpers::EMail::ContentParser.parse_bodies(unread_mail_bodies)
    pp mail_entries
    # if matches.nil?
    #   puts '0 UNFLAGGED EMAILS'
    # else
    #   matches.map { |match| @content_parser.improve_data(match) }
    #   pp matches.map(&:to_h) if ARGV.include?('debug')
    #
    #   # ynab_entries = @ynab_helper.build_entries(matches)
    #   # pp ynab_entries.map(&:to_h) if ARGV.include?('debug')
    #   # if ARGV.include?('push')
    #   #   puts "#{ynab_entries.size} ENTRIES ARE BEING CREATED"
    #   #   @ynab_helper.post_entries(ynab_entries, mail_helper)
    #   # else
    #   #   puts "#{ynab_entries.size} ENTRIES READY TO PUSH"
    #   # end
    # end
  end
end

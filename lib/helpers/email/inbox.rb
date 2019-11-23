# frozen_string_literal: true

require 'net/imap'
require 'mail'

module Helpers
  module EMail
    class Inbox
      class << self
        def load_unparsed_emails(mailbox)
          setup_connection

          return unless @imap.select(mailbox)

          @uids = fetch_unparsed_uids
          return nil unless @uids.any?

          fetch_mail_bodies(@uids)
        end

        def set_emails_to_flagged
          puts "FLAGGING #{@uids.size} EMAILS"
          @uids.each do |message_id|
            @imap.uid_store(message_id, '+FLAGS', [:Flagged])
          end
        end

        private

        def setup_connection
          @imap = Net::IMAP.new(ENV['EMAIL_SERVER'], ENV['PORT'], true)
          @imap.login(ENV['EMAIL'], ENV['PASSWORD'])
        end

        def fetch_unparsed_uids
          query = %w[NOT FLAGGED]
          @imap.uid_search(query)
        end

        def fetch_mail_bodies(uids)
          unread_mails_raw = @imap.uid_fetch(uids, 'RFC822')
          unread_mails_raw.map do |mail_body|
            mail = Mail.read_from_string(mail_body.attr['RFC822'])
            { mail_body.attr['UID'] => mail.text_part.body.to_s.force_encoding('utf-8') }
          end.reduce({}, :merge)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Helpers
  module EMail
    class ContentParser
      class << self
        def parse_bodies(bodies)
          mail_entries = []
          accounts = Helpers::Config::Loader.new.accounts

          bodies&.each do |uid, body|
            mail_entry = create_mail_entry(uid, match_mail_regexps(body))

            mail_entry.account = accounts[mail_entry.account.to_sym]
            mail_entry.payee_id = find_payee_id(mail_entry.memo)
            mail_entry.payee_name = find_payee_name(mail_entry.memo)

            mail_entries.push(mail_entry)
          end

          mail_entries
        end

        def find_date_in_memo(memo)
          memo.match(/([0-3][0-9]\.[0-1][0-9]\.20[0-9]{2})/).to_s
        end

        private

        def create_mail_entry(uid, args)
          entry_type = args.delete(:entry_type)

          if entry_type == 'Gutschrift'
            Models::EMail::Credit.new(uid, *args.values)
          elsif entry_type == 'Belastung'
            Models::EMail::Debit.new(uid, *args.values)
          else
            ::Exception.new('Unknown entry_type')
          end
        end

        def find_payee_id(memo)
          transfer_ids = Helpers::Config::Loader.new.transfer_ids.dup

          filtered_payees = transfer_ids.keys.filter do |key|
            memo.present? && memo.include?(key.to_s)
          end.reject(&:nil?)
          transfer_ids[filtered_payees.first] unless filtered_payees.nil? || filtered_payees.empty?
        end

        def find_payee_name(memo)
          regexps = Helpers::Config::Loader.new.payee_name_regexps.dup
          matches = regexps.map { |regex| memo.match(regex) }.reject(&:nil?)
          match = matches.first unless matches.empty?
          match[1] if match
        end

        def match_mail_regexps(content)
          email_parts_regexps = Helpers::Config::Loader.new.email_parts_regexps

          email_parts_regexps.map.with_index do |(key, regex)|
            matched = content.match(regex)
            matched_string = ''
            matched_string = matched[1] if matched.present? && matched[1].present?
            { key => matched_string }
          end.reduce({}, :merge)
        end
      end
    end
  end
end

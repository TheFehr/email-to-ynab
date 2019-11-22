# frozen_string_literal: true

module Helpers
  module EMail
    class ContentParser
      def self.parse_bodies(bodies)
        mail_entries = []

        bodies&.each do |uid, body|
          puts uid, body
          mail_entry = create_mail_entry(uid, match_mail_regexps(body))
          mail_entries.push(mail_entry)
        end

        mail_entries
      end

      def self.improve_data(data)
        more_accurate_date = find_date_in_memo(data[:memo])
        data[:valuta_date] = more_accurate_date if more_accurate_date.present?

        data[:payee_id] = find_payee_id(data[:memo])
        data[:payee_name] = find_payee_name(data[:memo])

        data[:cleared] = 'Cleared'
        data[:approved] = true
        data[:flag_color] = 'Blue'
      end

      def self.find_date_in_memo(memo)
        memo.match(/([0-3][0-9]\.[0-1][0-9]\.20[0-9]{2})/).to_s
      end

      private

      def self.create_mail_entry(uid, args)
        entry_type = args.delete(:entry_type)

        if entry_type == 'Gutschrift'
          Models::EMail::Credit.new(uid, *args.values)
        elsif entry_type == 'Belastung'
          Models::EMail::Debit.new(uid, *args.values)
        else
          ::Exception.new('Unknown entry_type')
        end
      end

      def self.find_payee_id(memo)
        find_transfer_payee(memo)
      end

      def self.find_payee_name(memo)
        find_payee_by_regex(memo)
      end

      def self.match_mail_regexps(content)
        email_parts_regexps = Helpers::Config::ConfigHelper.email_parts_regexps

        email_parts_regexps.map.with_index do |(key, regex)|
          matched = content.match(regex)
          matched_string = ''
          matched_string = matched[1] if matched.present? && matched[1].present?
          { key => matched_string }
        end.reduce({}, :merge)
      end

      def self.find_payee_by_regex(memo)
        matches = @payees_regexps.dup.map { |regex| memo.match(regex) }.reject(&:nil?)
        match = matches.first unless matches.empty?
        match[1] if match
      end

      def self.find_transfer_payee(memo)
        filtered_payees = @transfers.dup.keys.filter do |key|
          memo.present? && memo.include?(key.to_s)
        end.reject(&:nil?)
        @transfers[filtered_payees.first] unless filtered_payees.nil? || filtered_payees.empty?
      end
    end
  end
end

# frozen_string_literal: true

module Models
  module YNAB
    class Payee
      include ActiveModel::Model

      attr_accessor :name, :id

      validate :payee_info?

      def initialize(data)
        @name = data[:payee_name]
        @id = data[:payee_id]
      end

      private

      def payee_info?
        @name.present? || @id.present?
      end
    end
  end
end

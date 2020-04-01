# frozen_string_literal: true

module Models
  module YNAB
    class Payee
      include ActiveModel::Model

      attr_accessor :name, :id

      validates :name, presence: true, unless: :id
      validates :id, presence: true, unless: :name

      def initialize(data)
        @name = data[:payee_name]
        @id = data[:payee_id]
      end
    end
  end
end

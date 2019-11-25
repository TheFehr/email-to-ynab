# frozen_string_literal: true

require 'washbullet'

module API
  class Pushbullet
    def initialize
      return unless Helpers::Config::Loader.new.pushbullet[:active]

      @api = ::Washbullet::Client.new(Helpers::Config::Loader.new.pushbullet[:api_key])
    end

    def push_note(text)
      @api.push_note(
        receiver: :device,
        identifier: Helpers::Config::Loader.new.pushbullet[:device_id],
        params: {
          title: 'YNAB EMail Connector Info',
          body: text
        }
      )
    end
  end
end

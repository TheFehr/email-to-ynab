# frozen_string_literal: true

require 'washbullet'

module API
  class Pushbullet
    def initialize
      @configs = Helpers::Config::Loader.instance.pushbullet
      return unless @configs[:active]

      @api = ::Washbullet::Client.new(@configs[:api_key])
    end

    def push_note(text)
      @api.push_note(
        receiver: :device,
        identifier: @configs[:device_id],
        params: {
          title: 'YNAB EMail Connector Info',
          body: text
        }
      )
    end
  end
end

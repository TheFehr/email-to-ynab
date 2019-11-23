# frozen_string_literal: true

require 'washbullet'

module API
  class Pushbullet
    def initialize
      @api = ::Washbullet::Client.new(ENV['PUSHBULLET_API_KEY'])
    end

    def push_note(text)
      @api.push_note(
        receiver: :device,
        identifier: ENV['PUSHBULLET_DEVICE_ID'],
        params: {
          title: 'YNAB EMail Connector Info',
          body: text
        }
      )
    end
  end
end

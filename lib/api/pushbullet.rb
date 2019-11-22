# frozen_string_literal: true

module API
  class Pushbullet
    def initialize
      @api = Washbullet::Client.new(ENV['PUSHBULLET_API_KEY'])
    end

    def send_info(text)
      @api.push_note(
        receiver: :device,
        identifier: ENV['PUSHBULLET_DEVICE_ID'],
        params: {
          title: 'YNAB Connector Info',
          body: text
        }
      )
    end
  end
end

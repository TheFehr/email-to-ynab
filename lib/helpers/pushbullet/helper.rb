# frozen_string_literal: true

module Helpers
  module Pushbullet
    class Helper
      class << self
        def send_info(text)
          api = API::Pushbullet.new
          api.push_note(text)
        end
      end
    end
  end
end

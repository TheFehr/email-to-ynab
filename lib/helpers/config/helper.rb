# frozen_string_literal: true

module Helpers
  module Config
    module Helper
      DEFAULT_PATH = Pathname.new('./config/config.yaml')

      def self.set_config_path
        ARGV.each do |arg|
          arg_path = Pathname.new(arg)

          return arg_path if arg_path.readable? && arg_path.file?
        end

        DEFAULT_PATH
      end
    end
  end
end

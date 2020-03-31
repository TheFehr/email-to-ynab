# frozen_string_literal: true

require 'json-schema'
require 'pathname'

module Helpers
  module Config
    class Loader
      include Singleton

      SCHEMA_PATH = './lib/helpers/config/schema.json'
      DEFAULT_PATH = Pathname.new('./config/config.yaml')

      def initialize
        @config_path = set_config_path
      end

      def validate!(path = DEFAULT_PATH)
        JSON::Validator.validate!(schema_raw, config(path))
      end

      def payee_name_regexps
        @payee_name_regexps ||= config[:payee_name_regexps].map do |raw_regexp|
          Regexp.new(raw_regexp)
        end
      end

      def email_parts_regexps
        @email_parts_regexps ||= config[:email_parts_regexps].map do |key, raw_regexp|
          parsed_regex = Regexp.new(raw_regexp)
          parsed_regex = Regexp.new(raw_regexp, Regexp::MULTILINE) if key == :memo
          { key => parsed_regex }
        end.reduce({}, :merge)
      end

      def method_missing(name)
        return config[name.to_sym] if config.key? name.to_sym

        super
      end

      def respond_to_missing?(name)
        config.key? name.to_sym
      end

      private

      def config_raw(path = @config_path)
        @config_raw ||= File.read(path)
      end

      def config(path = @config_path)
        @config ||= YAML.safe_load(config_raw(path), symbolize_names: true)
      end

      def schema_raw(path = SCHEMA_PATH)
        @schema_raw ||= File.read(path)
      end

      def set_config_path
        ARGV.each do |arg|
          arg_path = Pathname.new(arg)

          return arg_path if arg_path.readable? && arg_path.file?
        end

        DEFAULT_PATH
      end
    end
  end
end

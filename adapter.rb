# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'active_support/core_ext/string'
require 'dotenv'
require 'require_all'

require_all 'lib'

Dotenv.load

EMailYNABAdapter.run

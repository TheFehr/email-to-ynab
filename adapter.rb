# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'active_support/core_ext/string'
require 'require_all'

require_all 'lib'

EMailYNABAdapter.run
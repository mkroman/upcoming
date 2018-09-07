# frozen_string_literal: true

require 'csv'
require 'date'

require 'mechanize'

require_relative 'videoeta/version'
require_relative 'videoeta/client'

module VideoETA
  # Client error indicating that the authentication failed.
  class AuthenticationError < StandardError; end
end

# frozen_string_literal: true

require 'uri'
require 'httpx'
require 'multi_json'

require_relative './netflix/client'
require_relative './netflix/movie'
require_relative './netflix/show'

module Upcoming
  module Netflix
    def self.new *args, **kwargs
      Client.new *args, **kwargs
    end
  end
end

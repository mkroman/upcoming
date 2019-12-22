#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift File.join(__dir__, 'lib')

require 'json'

require 'thin'
require 'sinatra'
require 'sinatra/json'

require 'upcoming'
require 'videoeta'

set :bind, '0.0.0.0'
set :protection, except: [:json_csrf]

before do
  # Have the CDN cache the response.
  cache_control :public, s_maxage: 36000
end

videoeta_client = VideoETA::Client.new(ENV['VIDEOETA_USER'],
                                       ENV['VIDEOETA_PASS'])

netflix_client = Upcoming::Netflix::Client.new

def get_videoeta_releases(videoeta_client)
  (1..12).map do |month|
    videoeta_client.bluray_releases_for_month(month)
  end.flatten
end

helpers do
  # Returns the wall time taken for the given block.
  #
  # @return [Float, Any] the wall time and the returned block result.
  def wall_time(&block)
    start = Time.now
    result = yield
    return (Time.now - start), result
  end
end

get '/' do
  videoeta_wall_time, videoeta_results = wall_time do
    get_videoeta_releases(videoeta_client)
  end

  videoeta_updated_at = DateTime.now

  json({
    success: true,
    videoeta: {
      results: videoeta_results,
      updated_at: videoeta_updated_at,
      wall_time: videoeta_wall_time,
    },
    updated_at: DateTime.now,
  })
end

get '/netflix' do
  json({
    success: true,
    netflix: netflix_client.upcoming
  })

end

error do
  json(success: false, error: 'server side error')
end

error 403 do
  json(success: false, error: "access forbidden: #{env['sinatra.error']}")
end

# frozen_string_literal: true

module Upcoming
  module Netflix
    class Client
      # @return [String] the base uri for the upcoming media API.
      BASE_URI = URI 'https://media.netflix.com/'
      # @return [Hash] a hash of headers that is sent with every request.
      REQUEST_HEADERS = {
        'User-Agent' => "mkroman-upcoming/#{Upcoming::Version} (https://github.com/mkroman/upcoming)"
      }

      # Constructs a new Netflix upcoming-releases-client.
      def initialize
        @http = HTTPX.plugin :compression
      end

      # Requests and returns the response for a HTTP request to the given path
      # on the base API.
      def get path
        uri = BASE_URI.dup.tap do |uri|
          uri.path = path
        end

        @http.get uri, headers: REQUEST_HEADERS
      end

      # Requests and returns a list of upcoming titles.
      #
      # @return [Array<Movie, Show>] list of upcoming movies and shows.
      def upcoming
        response = get '/gateway/v1/en/titles/upcoming'

        case response.status
        when 200
          json_data = MultiJson.load response.body.to_s
          result_total_items = json_data.dig 'meta', 'result', 'totalItems'

          if result_total_items
            json_data['items'].map do |item|
              klass = get_type_for_item item

              klass.from_json item
            end
          end
        end
      end

    private

      # @return [#from_json] a class appropriate that can wrap this item.
      def get_type_for_item item
        if (season = item['seasons']&.to_i) > 0
          Show
        else
          Movie
        end
      end
    end
  end
end

# frozen_string_literal: true

module Upcoming
  module Netflix
    class Movie
      # @return [String] the timezone for the releases.
      #
      # @note this is a complete guess based on the fact that the Netflix
      #   headquaters is located in San Francisco, which is in the Pacific Ocean
      #   timezone.
      RELEASE_TIMEZONE = '-08:00'

      # @return [Integer] the API-internal id.
      attr_accessor :id

      # @return [String] the movie title.
      attr_accessor :title

      # @return [DateTime] the movie premiere date.
      attr_accessor :premiere_date

      # @return [String] the distribution model for this movie.
      attr_accessor :distribution

      # @return [String] the locale of this production.
      attr_accessor :locale

      # Constructs a new +Movie+ with the given +id+ and +title+.
      def initialize id, title
        @id = id
        @title = title
      end

      def to_json *args
        {
          'id' => @id,
          'title' => @title,
          'locale' => @locale,
          'premiere_date' => @premiere_date,
          'type' => 'movie',
        }.to_json *args
      end

      # Creates a new Movie instance from JSON data straight from the API.
      #
      # @returns [Movie] the movie instance.
      def self.from_json json
        id = json['id'].to_i
        name = json['name']

        Movie.new(id, name).tap do |movie|
          movie.distribution = json['distribution']

          premiere_date = DateTime.parse json['premiereDate']
          premiere_date.new_offset RELEASE_TIMEZONE

          movie.premiere_date = premiere_date

          movie.locale = json['locale']
        end
      end
    end
  end
end

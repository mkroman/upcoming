# frozen_string_literal: true

module Upcoming
  module Netflix
    # Class that represents a TV show with at least 1 upcoming season. It is
    # virtually the same as +Movie+ except it has a season attribute.
    class Show < Movie
      # @return [Integer] the number for the season that is being released.
      attr_accessor :seasons

      def to_json *args
        {
          'id' => @id,
          'title' => @title,
          'locale' => @locale,
          'premiere_date' => @premiere_date,
          'seasons' => @seasons,
          'type' => 'show'
        }.to_json *args
      end

      # Creates a new Show instance from json data.
      #
      # @returns [Show] the show instance.
      def self.from_json json
        id = json['id'].to_i
        name = json['name']

        Show.new(id, name).tap do |show|
          show.distribution = json['distribution']

          premiere_date = DateTime.parse json['premiereDate']
          premiere_date.new_offset RELEASE_TIMEZONE

          show.premiere_date = premiere_date

          show.locale = json['locale']
          show.seasons = json['seasons']&.to_i
        end
      end
    end
  end
end


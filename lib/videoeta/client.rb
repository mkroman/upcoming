# frozen_string_literal: true

module VideoETA
  class Client
    # Constructs a new Client with the given +username+ and +password+.
    def initialize(username, password)
      @username = username
      @password = password
      @authenticated = false

      @agent = Mechanize.new
      @agent.log = Logger.new(STDOUT, level: :error)
      @agent.user_agent_alias = 'Linux Firefox'
    end

    # Will attempt to sign in with the stored credentials.
    #
    # @raise [AuthenticationError] if the authentication fails
    # @return true if authentication succeeds
    def authenticate
      page = @agent.get('https://videoeta.com/users/sign_in')

      login_form = page.form_with(id: 'new_user')
      login_form.field_with(name: 'user[login]')&.value = @username
      login_form.field_with(name: 'user[password]')&.value = @password

      login_result = @agent.submit(login_form)

      unless alert = login_result.at_css('div.alert-danger')
        @authenticated = true
      else
        raise AuthenticationError, alert.text
      end
    end

    # Returns a list of upcoming titles in the given +month+ and +year+.
    #
    # @param month [Integer] the month to get releases for (can range from 1-12)
    # @param year [Integer] the year to get releases for
    #
    # @note The data for the requested +year+ might not be available.
    # @return [Array<Hash>] list of upcoming titles
    def bluray_releases_for_month(month, year = Time.now.year)
      authenticate unless @authenticated

      days_in_month = Date.new(year, month, -1).day

      params = {
        'blurayf[]' => 1,
        'keywords' => '*',
        'datetype' => 'bdreleases',
        'search_type' => 'daterange',
        'start_date' => "#{month}/01/#{year}",
        'end_date' => "#{month}/#{days_in_month}/#{year}",
        'ord_by' => 'box_office',
        'ord_sort' => 'desc',
      }

      page = @agent.get("/search.csv", params)
      results = []

      # The CSV file is encoded as ISO-8559-1. Transcode it to UTF-8.
      page.body.encode!('utf-8', 'iso-8859-1')

      CSV.parse(page.body, headers: true) do |row|
        result = format_hash_row!(row.to_hash)
        results << result
      end

      results
    end

  private

    # List of CSV fields that can be parsed as dates using `Date.parse`.
    ROW_DATE_FIELDS = %w[bluray_release_date
                         dvd_release_date
                         4kud_release_date].freeze

    # Updates date fields in `row` to parsed dates.
    def format_hash_row!(hash)
      ROW_DATE_FIELDS.each do |field|
        if hash.key?(field) and !hash[field].nil?
          hash[field] = DateTime.parse(hash[field])
        end
      end

      hash
    end
  end
end

require 'json'
require 'uri'

class Movie < ApplicationRecord
  def self.find_in_tmdb(search)
    search = search.to_h.symbolize_keys
    return [] if search[:title].blank?

    query = {
      api_key: ENV.fetch('TMDB_API_KEY', ''),
      query: search[:title]
    }
    query[:year] = search[:release_year] if search[:release_year].present?
    query[:language] = 'en-US' if search[:language] == 'en'

    uri = URI('https://api.themoviedb.org/3/search/movie')
    uri.query = URI.encode_www_form(query)

    response = Faraday.get(uri.to_s)
    return [] unless response.success?

    results = JSON.parse(response.body).fetch('results', [])

    results.filter_map do |result|
      next if where(title: result['title']).exists?

      release_date =
        begin
          Date.parse(result['release_date']) if result['release_date'].present?
        rescue ArgumentError
          nil
        end

      new(
        title: result['title'],
        rating: 'R',
        release_date: release_date,
        description: result['overview']
      )
    end
  end

  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
end
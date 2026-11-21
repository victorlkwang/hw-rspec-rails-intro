require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe '.find_in_tmdb' do
    it 'returns unsaved Movie objects from the TMDb response' do
      results = Movie.find_in_tmdb(
        title: 'Olympics',
        release_year: '2000',
        language: 'all'
      )

      expect(results.length).to eq(1)
      expect(results.first).to be_a(Movie)
      expect(results.first).not_to be_persisted
      expect(results.first.title).to eq('Sydney 2000 Olympics Opening Ceremony')
      expect(results.first.rating).to eq('R')
      expect(results.first.release_date).to eq(Date.new(2000, 9, 15))
    end
  end
end
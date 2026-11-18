require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'searching TMDb' do
    let(:fake_results) { [double('movie1'), double('movie2')] }

    it 'calls the model with the search fields' do
      expect(Movie).to receive(:find_in_tmdb)
        .with(title: 'Manhunter', release_year: '1986', language: 'en')
        .and_return(fake_results)

      get :search_tmdb, params: {
        title: 'Manhunter',
        release_year: '1986',
        language: 'en'
      }
    end

    it 'renders the search page and assigns results' do
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)

      get :search_tmdb, params: { title: 'Manhunter' }

      expect(response).to render_template('search_tmdb')
      expect(assigns(:movies)).to eq(fake_results)
    end

    it 'asks for a title when the submitted title is blank' do
      get :search_tmdb, params: { title: '', release_year: '', language: 'all' }

      expect(flash[:danger]).to eq('Please fill in all required fields!')
    end
  end

  describe 'adding a movie' do
    it 'saves the movie and redirects to search' do
      expect {
        post :add_movie, params: {
          title: 'Example Movie',
          rating: 'R',
          release_date: '2000-09-15',
          description: 'Example description'
        }
      }.to change(Movie, :count).by(1)

      expect(response).to redirect_to(search_path)
      expect(flash[:success]).to include('Example Movie')
    end
  end
end
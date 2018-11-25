require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:movie_params) { {title: 'Wrecking Ralph', rating: 'PG', description: 'Fix it Phelix', release_date: 2.years.ago, director: 'Walt Disney'} }
  let(:movie) { Movie.create!(movie_params) }
  describe 'GET index' do
    it 'renders the correct template' do
      get :index
      expect(response).to render_template 'index'
      expect(response).to be_success
    end
    it 'sorts by title when title is passed by params' do
      get :index, {sort: 'title'}

      expect(response).to redirect_to movies_path(sort: 'title', ratings: {'PG-13'=> 'PG-13', 'PG'=> 'PG', 'NC-17'=>'NC-17', 'G'=> 'G', 'R'=>'R'})
    end
    it 'sorts by release_date when title is passed by params' do
      get :index, {sort: 'release_date'}

      expect(response).to redirect_to movies_path(sort: 'release_date', ratings: {'PG-13'=> 'PG-13', 'PG'=> 'PG', 'NC-17'=>'NC-17', 'G'=> 'G', 'R'=>'R'})
    end
  end
  describe 'GET show' do
    it 'displays a movie' do
      id = {id: movie.id}
      get :show, id
      expect(response).to render_template 'show'
    end
  end
  describe 'POST create' do
    it 'creates a movie' do
      post :create, { movie: movie_params }
      expect(Movie.all.count).to eq(1)
    end
    it 'redirects to index' do
      post :create, { movie: movie_params }
      expect(response).to redirect_to movies_path
    end
  end
end

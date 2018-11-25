require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:movie_params) { {title: 'Wrecking Ralph', rating: 'PG', description: 'Fix it Phelix', release_date: 4.years.ago, director: 'Rich More'} }
  let(:movie) { Movie.create!(movie_params) }
  let(:movie_with_director) { Movie.create!({title: 'Zootopia', rating: 'PG', description: 'Fix it Phelix', release_date: 2.years.ago, director: 'Rich More'})}
  let(:movie_without_director) { Movie.create!({title: 'Finding Nemo', rating: 'PG', description: 'Fix it Phelix', release_date: 2.years.ago, director: nil})}
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
  describe 'GET edit' do
    it 'loads the edit page for a given movie' do
      get :edit, {id: movie.id}
      expect(response).to render_template 'edit'
      expect(response).to be_success
    end
  end

  describe 'POST update' do
    before(:each) do
      @title = "Wreck it ralph"
      movie_params[:title] = @title
      post :update, id: movie.id, movie: movie_params
      @updated_movie = Movie.find(movie.id)
    end
    it 'updates given movie record' do
      expect(@updated_movie.title).to eq(@title)
    end
    it 'redirects to index page' do
      expect(response).to redirect_to(movie_path(@updated_movie))
    end
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: movie.id
    end
    it "deletes a given movie from the database" do
      expect(Movie.find_by(title: 'Wrecking Ralph')).to be_nil
    end
    it "redirects to the movies_path" do
      expect(response).to redirect_to movies_path
    end
  end

  describe 'GET director' do
    before do

    end
    it 'displays movies by a given director' do
      movie
      movie_with_director
      movie_without_director
      get :movies_by_director, id: movie.id
      expect(response).to render_template('movies_by_director')
    end
    it 'redirects to index if movie has no director' do
      get :movies_by_director, id: movie_without_director.id
      expect(response).to redirect_to(root_path)
    end
  end
end

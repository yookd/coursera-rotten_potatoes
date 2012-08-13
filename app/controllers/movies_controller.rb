class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    # RESTful URIs
    if session[:ratings] && !params[:ratings]
      if session[:redirect] == false || session[:redirect].nil?
        session[:redirect] = true
        redirect_to movies_path(session[:ratings])
      else
        session[:redirect] = false
      end
    end

    # If new filter params are specified, save them in session
    if params[:commit] == 'Refresh'
      session[:ratings] = params[:ratings]
    elsif params[:ratings] != session[:ratings]
      # Save
      params[:ratings] = session[:ratings]
    end

    # Check if we are sorting, save in session
    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      # Save
      params[:sort] = session[:sort]
    end

    # Store the ratings and sort for highlight and retaining checkboxes
    @ratings = session[:ratings]
    @sort = session[:sort]

    # Check if session exists
    if session[:ratings] && session[:sort]
      @movies = Movie.find_all_by_rating(session[:ratings].keys, :order => session[:sort])
    else
      @movies = nil
    end

    #@movies = Movie.all

    # if none of the ratings are checked, none should be displayed

    # if filter -> filter the results
    # store the ratings somehwere to display on the next view

    # if sort -> see if there is anything set in the filter
    # if there is, we sort the filter
    # make sure we return the filter as well
    
    #@movies = Movie.find_all_by_rating(params[:ratings].keys).order('title') if params[:commit] == 'Refresh' && params[:sort] == 'title'
    #@movies = Movie.find_all_by_rating(params[:ratings].keys, :order => 'release_date') if params[:commit] == 'Refresh' && params[:sort] == 'release_date'
    #@movies = Movie.find_all_by_rating(params[:ratings].keys) if params[:commit] == 'Refresh' && params[:sort].nil?
    #@movies = Movie.find_all_by_rating(params[:ratings].keys, :order => 'title') if params[:commit] == 'Refresh' && if params[:sort] == 'title'
    #@movies = @movies.order('title') if params[:sort] == 'title'
    #@movies = @movies.order('release_date') if params[:sort] == 'release_date'

    @all_ratings = Movie.ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

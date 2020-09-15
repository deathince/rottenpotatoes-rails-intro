class MoviesController < ApplicationController
  
  helper_method :hilight
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    arrays=[]
    temprats=Movie.all
    temprats.each do |movie|
      arrays.append(movie.rating)
    end
    @all_ratings=arrays.uniq
    if params[:ratings].nil?
      @movies = Movie.order params[:order]
    else
      array_ratings = params[:ratings].keys
      @movies = Movie.where(rating: array_ratings).order params[:order]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def hilight(column)
    if(params[:order].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end
end


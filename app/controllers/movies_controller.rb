class MoviesController < ApplicationController
  helper_method :picked_rating?
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
    # everytime params is updated and not null, update sessions
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    if !params[:order].nil?
      session[:order] = params[:order] unless params[:order].nil?
    end
    # get the unique rating, notice that if there is only 4 out of 5 rating available in movies, the check box will only show 4 as well
    arrays=[]
    temprats=Movie.all
    temprats.each do |movie|
      arrays.append(movie.rating)
    end
    @all_ratings=arrays.uniq
    
    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:order].nil? && !session[:order].nil?)
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    elsif !params[:ratings].nil? || !params[:order].nil?
      if !params[:ratings].nil?
        array_ratings = params[:ratings].keys
        return @movies = Movie.where(rating: array_ratings).order(session[:order])
      else
        return @movies = Movie.all.order(session[:order])
      end
    else
      return @movies = Movie.all
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
    if(session[:order].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end
  
  def picked_rating?(rating)
    picked_rating_arr = session[:ratings]
    return true if picked_rating_arr.nil?
    picked_rating_arr.include? rating
  end
end


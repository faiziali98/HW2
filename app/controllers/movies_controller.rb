class MoviesController < ApplicationController
  attr_accessor :hilite, :sort 
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def movie_up
    params.require(:movie).permit(:toup, :title, :rating, :description, :release_date)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @hilite = "hilite"
    if (params.has_key?(:sort_by))
      @movies = Movie.order ("#{params[:sort_by]} ASC")
      @sort = params[:sort_by]
    else
      @movies = Movie.all
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
  
  def upmovie
  end
  
  def ups
    k = movie_up[:toup]
    t = movie_up[:title]
    rat = movie_up[:rating]
    
    @movie = Movie.find_by title: k
    
    if (@movie!=nil)
      if (t=="" || rat=="")
        flash[:notice] = "Error no field can be empty"
        redirect_to movie_path(@movie)
        return
      end
      @movie.update_attributes!(movie_params)
      flash[:notice] = "Successfully updated."
      redirect_to movie_path(@movie)
      return
    else
      flash[:notice] = "#{k} Error no such movie found."
      redirect_to movies_path
      return
    end
  end
  
  def delete
  end
  
  def delmov
    t = movie_up[:title]
    rat = movie_up[:rating]
    if (t!=nil)
      @movie = Movie.find_by title: t
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
      return
    elsif(rat!=nil)
      movies = Movie.where(rating: rat)
      movies.all.each do |movie|
        movie.destroy
      end
      redirect_to movies_path
      return
    else
      redirect_to movies_path
      return
    end
  end
end

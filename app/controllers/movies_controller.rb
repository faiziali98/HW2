class MoviesController < ApplicationController
  attr_accessor :hilite, :sort, :all_ratings
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
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @hilite = "hilite"
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort_by] = params[:sort_by] if params[:sort_by]

    if session[:ratings] || session[:sort_by]
      @sort = session[:sort_by]
      @ratings = session[:ratings].keys if session[:ratings].respond_to?(:keys)
      @movies = Movie.where("rating IN (?)", @ratings).order(session[:sort_by])
    else
      session[:ratings] = {'G'=>1, 'PG'=>1, 'PG-13'=>1, 'R'=>1} if not session[:ratings]
      @movies = Movie.all
    end

    if session[:ratings] != params[:ratings] || session[:sort_by] != params[:sort_by]
      redirect_to movies_path(ratings: session[:ratings], sort_by: session[:sort_by])
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
    rdate = movie_up[:release_date]
    rat = movie_up[:rating]
    uphash={}
    @movie = Movie.find_by title: k
    
    if (@movie!=nil)
      uphash[:title]= if (t=="") then @movie.title else t end 
      uphash[:release_date]= if (rdate=="") then @movie.release_date else release_date end 
      uphash[:rating]= if (rat=="") then @movie.rating else rat end
      @movie.update_attributes!(uphash)
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

define ['vendor/jquery'], ($) ->

  module = {}

  module.getAllMovieRatings = (callback) -> $.get '/api/movieratings', callback

  module.getMovieRating = (movie, callback) -> $.get '/api/ratemovie/' + movie, callback

  module.postMovieRating = (movie, rating) -> $.post '/api/movieratings/' + movie, {rating: rating}

  module.putMovieRating = (movie, ratings) -> 
    $.ajax 
      url: '/api/movieratings/' + movie 
      type: 'PUT'
      data: {ratings: ratings}

  module.deleteMovieRating = (movie) -> 
    $.ajax
      url: '/api/movieratings/' + movie
      type: 'DELETE'

  return module
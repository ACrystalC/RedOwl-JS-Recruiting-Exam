requirejs.config
  baseUrl: '/javascripts'
  paths:
    vendor: './vendor'
  shim:
    'vendor/jquery':
      exports: 'jQuery'
    'vendor/underscore':
      exports: '_'
    'vendor/handlebars':
      exports: 'Handlebars'

dependencies = [
  'vendor/jquery'
  'vendor/underscore'
  'vendor/handlebars'
  'movie-ratings-service-client'
]

requirejs dependencies, ($, _, Handlebars, ratingsService) ->
  wrapTemplate = """
                  <div class="wrap">
                    <div class="main__title">
                        <h1>Movies!</h1>
                    </div>
                    <div class="movies"></div>
                  </div>
                  """

  ratedMovieTemplate = """
                      <div class="movie">
                        <a href=# class="movie--close"><img src="/images/trash.png"></a>
                        <div class="movie__title">
                          {{movieName}}
                        </div>
                        <div class="movie__rating">
                          {{rating}}
                          <button class="movie__rate">+ add rating</button>
                        </div>
                      </div>
                      """
  addMovieTemplate = """
                      <div class="movie-add">
                        <button class="movie-add__button">+ ADD A MOVIE</button>
                      </div>
                     """

  wrapSection = Handlebars.compile wrapTemplate
  ratedMovieSection = Handlebars.compile ratedMovieTemplate
  addMovieSection = Handlebars.compile addMovieTemplate

  ratingsService.getAllMovieRatings (ratings) ->
    console.log(ratings)
    $('body').append wrapSection
    for movie of ratings
      do (movie) ->
        ratingsService.getMovieRating movie, (rating) ->
          if rating % 1 != 0
            rating = Math.round(rating * 10) /10
          $('.movies').append ratedMovieSection { movieName: movie, rating: rating }
    $('.wrap').append addMovieSection

  # Delete movie
  $('body').on 'click', '.movie--close', (e) ->
    e.preventDefault()
    movie = $(this).next().text().trim()
    ratingsService.deleteMovieRating movie
    $(this).parent().hide()

  # Open movie rating input field
  $('body').on 'click', '.movie__rate', () ->
    $(this).replaceWith('<input class="rating__input" type="text" name="rating" placeholder="Enter a rating">')
    $('.rating__input').focus()

  # Submit rating when user presses enter in the field
  $('body').on 'keypress', '.rating__input', (e) ->
    if e.which == 13
      $this = $(this)
      movieRating = $this.parent()
      rating = $this.val()
      movie = movieRating.prev().text().trim()
      ratingsService.postMovieRating movie, rating
      ratingsService.getMovieRating movie, (rating) ->
        console.log(typeof rating)
        if rating % 1 != 0
          rating = Math.round(rating * 10) /10
        movieRating.text(rating).append('<button class="movie__rate">+ add rating</button>')

  # Open movie create form
  $('body').on 'click', '.movie-add__button', () ->
    $(this).replaceWith('<form class="movie-add__form"><input class="movie-add__input" type="text" name="movie" placeholder="Movie Title"><br /><input class="movie-add__input" type="text" name="rating" placeholder="Rating, Rating"><br /><button class="movie-add__submit">Submit</button></form>')
    $('.movie-add__input').first().focus()

  # Submit movie
  $('body').on 'click', '.movie-add__submit', (e) ->
    e.preventDefault()
    movie = $('.movie-add__input').first().val()
    ratings = $(this).prev().prev().val().split(', ')
    ratingsService.putMovieRating movie, ratings
    ratingsService.getMovieRating movie, (rating) ->
      console.log(rating)
      if rating % 1 != 0
        rating = Math.round(rating * 10) /10
      $('.movies').append ratedMovieSection { movieName: movie, rating: rating }
      $('.movie-add__form').replaceWith('<button class="movie-add__button">+ ADD A MOVIE</button>')

  # Close input/form and replace with buttons when user clicks outside of elements
  $(document).click (e) ->
    if e.target.nodeName != 'BUTTON' and e.target.nodeName != 'INPUT'
      $('.rating__input').replaceWith('<button class="movie__rate">+ add rating</button>')
      $('.movie-add__form').replaceWith('<button class="movie-add__button">+ ADD A MOVIE</button>')

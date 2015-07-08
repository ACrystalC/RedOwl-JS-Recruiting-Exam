_ = require 'underscore'
assert = require 'assert'

MovieRatingsResource = require '../app/movie-ratings'

describe 'MovieRatingsResource', ->

  movieRatings = {}

  beforeEach ->
    movieRatings = new MovieRatingsResource
      'Bladerunner': [5, 1]
      'The Empire Strikes Back': [1, 1, 2, 3, 5]

  describe '#getAllMovieRatings()', ->

    it 'should return the correct ratings for all movies', ->
      bladeRunner = movieRatings.getAllMovieRatings()['Bladerunner']
      theEmpire = movieRatings.getAllMovieRatings()['The Empire Strikes Back']
      assert.equal _.difference(bladeRunner, [1, 5]).length, 0
      assert.equal _.difference(theEmpire, [1, 1, 2, 3, 5]).length, 0


  describe '#getMovieRatings()', ->

    it 'should return the correct movie ratings for the requested movie', ->
      bladeRunner = movieRatings.getMovieRatings('Bladerunner')
      assert.equal _.difference(bladeRunner, [1, 5]).length, 0

    it 'should throw an error if the requested movie does not exist in the repo', ->
      assert.throws (-> movieRatings.getMovieRatings 'Leon: The Professional'), /Movie does not exist in repository/

  describe '#putMovieRatings()', ->

    it 'should put a new movie with ratings into the repo and return the ratings', ->
      leon = movieRatings.putMovieRatings('Leon: The Professional', [3, 4, 4, 5])
      assert.equal _.difference(leon, [3, 4, 4, 5]).length, 0

    it 'should overwrite the ratings of an existing movie in the repo and return the new ratings', ->
      bladeRunner = movieRatings.putMovieRatings('Bladerunner', [3, 4, 4, 5])
      assert.equal _.difference(bladeRunner, [3, 4, 4, 5]).length, 0

  describe '#postMovieRating()', ->

    it 'should put a new movie with rating into the repo if it does not already exist and return the rating', ->
      leon = movieRatings.postMovieRating('Leon: The Professional', 5)
      assert.equal _.difference(leon, [3, 4, 4, 5, 5]).length, 0

    it 'should add a new rating to an existing movie in the repo and return the ratings', ->
      bladeRunner = movieRatings.postMovieRating('Bladerunner', 4)
      assert.equal _.difference(bladeRunner, [1, 5, 4]).length, 0

  describe '#deleteMovieRatings()', ->

    it 'should delete a movie from the ratings repo', ->
      assert.equal movieRatings.deleteMovieRatings('Bladerunner'), true

    it 'should throw an error when attempting to delete a movie that does not exist', ->
      assert.throws (-> movieRatings.deleteMovieRatings 'Leon: The Professional'), /Movie does not exist in repository/

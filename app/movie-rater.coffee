_ = require 'underscore'

class MovieRater
  constructor: (ratings) ->
    if ratings.constructor == Array and arguments.length == 1
      # Return object where key is rating and value is count of rating in ratings
      groupedRatings = _.countBy(ratings, (num) -> num)
      ratingsKeys = _.keys(groupedRatings)
      if ratingsKeys.length >= 3 # Need at least 3 ratings to get trimmed average
        ratingsKeys = _.map(ratingsKeys, (key) -> Number(key)) # Convert key from string to number
        sortedKeys = _.sortBy(ratingsKeys, (num) -> num) # Sort keys numerically
        minimal =  _.first(sortedKeys)
        maximal = _.last(sortedKeys)
        delete groupedRatings[minimal]
        delete groupedRatings[maximal]
        # Return array without specified values. Since array is sorted similar effect to pop/shift
        sortedKeys = _.without(sortedKeys, minimal, maximal )
        trimmedNum = 0
        _.map(sortedKeys, (key) -> trimmedNum = trimmedNum + groupedRatings[key] * key)
        return trimmedNum / sortedKeys.length
      else
        throw new Error('Not enough ratings')
    else
      throw new Error('Invalid arguments')

module.exports = MovieRater
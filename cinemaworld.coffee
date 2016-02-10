#
# Description:
#   Gets a list of movies being shown at cinemaworld
# 
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CINEMAWORLD_API_KEY - Pretty self explanatory... 
#
# Commands:
#   hubot movies - Get a list of movies
#
# Notes:
# 
# Author:
#   Nadir	

key = process.env.HUBOT_CINEMAWORLD_API_KEY
cinema_id = 30 
url = "http://www2.cineworld.co.uk/api/quickbook/films?key=#{key}&cinema=#{cinema_id}"
getMovies = (msg) ->
  msg.http(url)
    .get() (err, res, body) ->
      if res.statusCode != 200
        msg.send "Seems that the cinemaworld API is a big pile of shit...\n#{body}"
      else
        response = ''
        movies = JSON.parse(body).films
        for m in movies
          movie = m.title.replace /2D - /, ""
          movie = movie.replace /\ - Movies For Juniors/, ""
          movie = movie.replace /\ - Unlimited Screening/, ""
          response += "\n#{movie}"
        msg.send response 

module.exports = (robot) ->
  robot.respond /movies/i, (msg) ->
    getMovies(msg)

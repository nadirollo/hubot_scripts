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
d = new Date
month = d.getMonth() + 1
month = '0' + month if month < 10
date = "#{d.getFullYear()}#{month}#{d.getDate()}"  
movies_url = "http://www2.cineworld.co.uk/api/quickbook/films?key=#{key}&cinema=#{cinema_id}"
performances_url= "http://www2.cineworld.co.uk/api/quickbook/performances?key=#{key}&cinema=#{cinema_id}&date=#{date}"
message = ''

getMovies = (msg) ->
  msg.http(movies_url)
    .get() (err, res, body) ->
      if res.statusCode != 200
        msg.send "Seems that the cinemaworld API is a big pile of shit...\n#{body}"
      else
        message += 'Hammersmith Cinemaworld:'
        movies = JSON.parse(body).films
        for m in movies
          movie = m.title.replace /2D - /, ""
          movie = movie.replace /\ - Movies For Juniors/, ""
          movie = movie.replace /\ - Unlimited Screening/, ""
          getPerformances(msg, m.edi, movie)
        msg.send response 

getPerformances = (msg, movie_id, movie) ->
  msg.http(performances_url + "&film=#{movie_id}")
    .get() (err, res, body) ->
      times = ''
      if res.statusCode != 200
        msg.send "Seems that the cinemaworld API is a big pile of shit...\n#{body}"
      else
        performances = JSON.parse(body).performances
        times += " [#{p.time}]" for p in performances
        message += "\n#{movie} - #{times}"
        msg.send "#{performances_url}&film=#{movie_id}"

module.exports = (robot) ->
  robot.respond /movies/i, (msg) ->
    getMovies(msg)

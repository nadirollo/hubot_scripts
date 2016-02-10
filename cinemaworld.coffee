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
#date = "#{d.getFullYear()}#{month}#{d.getDate()}"  
date = "20160211"
movies_url = "http://www2.cineworld.co.uk/api/quickbook/films?key=#{key}&cinema=#{cinema_id}&date=#{date}"
performances_url= "http://www2.cineworld.co.uk/api/quickbook/performances?key=#{key}&cinema=#{cinema_id}&date=#{date}"

getMovies = (msg) ->
  msg.http(movies_url)
    .get() (err, res, body) ->
      if res.statusCode != 200
        msg.send "Seems that the cinemaworld API is a big pile of shit...\n#{body}"
      else
        msg.send "Cinemaworld @ Hammersmith today:"
        movies = JSON.parse(body).films
        for m in movies
          movie = m.title.replace /2D - /, ""
          movie = movie.replace /\ - Movies For Juniors/, ""
          movie = movie.replace /\ - Unlimited Screening/, ""
          getTimes(msg, m.edi, movie)


getTimes = (msg, movie_id, movie) ->
  msg.http(performances_url + "&film=#{movie_id}")
   .get() (err, res, body) ->
     perfs = ''
     if res.statusCode != 200
       msg.send "Seems that the cinemaworld API is a big pile of shit...\n#{body}"
     else
       message = ''
       performances = JSON.parse(body).performances
       message += " [#{p.time}]" for p in performances
       msg.send "#{movie} - #{message}"



module.exports = (robot) ->
  robot.respond /movies/i, (msg) ->
    getMovies(msg)

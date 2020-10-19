require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character_name)
  #make the web request

  response_string = RestClient.get('http://swapi.dev/api/people')
  response_hash = JSON.parse(response_string)
  results = response_hash["results"]

  character_hash = find_hash(results, character_name)
  
  # iterate over the response hash to find the collection of `films` for the given
  #   `character`
  film_urls = get_films(character_hash)

  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  films = film_info(film_urls)

  # this collection will be the argument given to `print_movies`
  #  and that method will do some nice presentation stuff like puts out a list
  #  of movies by title. Have a play around with the puts with other info about a given film.

  print_movies(films)
  binding.pry
end

def find_hash(results, character)
  results.find do |char_hash|
    char_hash["name"] == character
  end
end

def get_films(character_hash)
  character_hash["films"]
end

def film_info(urls)
  urls.map do |url|
    response_hash = RestClient.get(url)
    results = JSON.parse(response_hash)
  end
end

def print_movies(films)
  # some iteration magic and puts out the movies in a nice list
  titles = get_titles(films)
  puts "Titles: #{titles}"
end

def get_titles(films)
  films.map do |film|
    film["title"]
  end
end

def show_character_movies(character)
  films = get_character_movies_from_api(character)
  print_movies(films)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?

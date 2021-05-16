require 'mechanize'

class Scraping < ApplicationRecord
  def self.scrape
    agent = Mechanize.new
    chord = Chord.new
    # page = agent.get("https://music.j-total.net/data/014se/012_sekaino_owari/037.html")
    page = agent.get("https://music.j-total.net/data/014se/012_sekaino_owari/037.html")
    
    
    chord.song = page.search("/html/body/div[3]/div[1]/div[1]/h1").inner_text
    
    credits = page.search("/html/body/div[3]/div[1]/div[1]/h2").inner_text
    chord.artist = credits.split("/")[0].slice(2..)
    
    # elements = page.search("/html/body/div[3]/div[1]/p[1]/tt/a")
    # chords = ""
    # elements.each do |element|
    #   chords += element.inner_text
    # end
    # chord.chord1st = chords
    chord.chord1st = page.search("/html/body/div[3]/div[1]/p[1]/tt/a").inner_text
    
    chord.save
  end
end

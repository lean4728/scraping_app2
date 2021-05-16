require 'mechanize'

class Scraping2 < ApplicationRecord
  def self.scrape
    agent = Mechanize.new
    links = []
    next_urls = ""

    while true
      current_page = agent.get("https://music.j-total.net/sp/as/")

      # 次のページのリンクタグを代入する変数を準備
      next_link =

      # 次のページのリンクタグがなければwhile分から抜ける
      break unless next_link

      # パスを取得
      next_url = ""
    end







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

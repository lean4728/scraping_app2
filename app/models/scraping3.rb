require 'mechanize'

# class Scraping3
#   def self.scrape
    agent = Mechanize.new
    links_1 = []
    page = agent.get("https://music.j-total.net/sp/as/")
    page.links[7..44] .each { |l| links_1 << l.href }
    page.links[47..52].each { |l| links_1 << l.href }
    # links_1.each { |l| puts l }
    
    links_1.each do |link_1|
      links_2 = []
      page = agent.get("https:" + link_1)
      elements = page / "/html/body/ul[3]/li/a"
      elements.each { |e| links_2 << e.get_attribute("href") }    
      #links_2.each { |l| puts l }
      
      links_2.each do |link_2|
        links_3 = []
        begin
          page_2 = agent.get("https:" + link_2)
        rescue
          puts "GETリクエストエラー発生"
          puts "https:" + link_2
          puts ""
        end
        elements = page / "/html/body/table[6]/tr/td/div/form/p/a[@target='_blank']"
        elements.each { |e| links_3 << e.get_attribute("href") }
        # links_3.each { |l| puts l }
      end
    end

      # chord.song = page.search("/html/body/div[3]/div[1]/div[1]/h1").inner_text
      
      # credits = page.search("/html/body/div[3]/div[1]/div[1]/h2").inner_text
      # chord.artist = credits.split("/")[0].slice(2..)
      
      # # elements = page.search("/html/body/div[3]/div[1]/p[1]/tt/a")
      # # chords = ""
      # # elements.each do |element|
      # #   chords += element.inner_text
      # # end
      # # chord.chord1st = chords
      # chord.chord1st = page.search("/html/body/div[3]/div[1]/p[1]/tt/a").inner_text
      
      # chord.save
#   end
# end

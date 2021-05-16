require 'mechanize'

HTTPS                = "https:"
LINK_0               = "//music.j-total.net/sp/as/"
LINK_2_DIR           = "//music.j-total.net/dbsp/"
ERRMSG_GET_LINK      = "GETリクエストエラー発生"
XPATH_LINK_0         = "/html/body/table[4]/tr/td/div/a"
XPATH_LINK_1         = "/html/body/ul[3]/li/a"
XPATH_LINK_2         = "/html/body/table[6]/tr/td/div/form/p/a[@target='_blank']"
XPATH_LINK_2_NEXT    = "/html/body/center[3]/font/a"
XPATH_LINK_2_NEXT_2  = "/html/body/center[3]/font/a[2]"
XPATH_LINK_3_SONG    = "/html/body/table[4]/tr/td[1]/table/tr/td/table/tr[1]/td[1]/font/b"
XPATH_LINK_3_SONG_2  = "/html/body/div[3]/div[1]/div[1]/h1"
XPATH_LINK_3_CREDITS = "/html/body/div[3]/div[1]/div[1]/h2"
XPATH_LINK_3_CHORDS  = "/html/body/div[3]/div[1]/p[1]/tt/a"

def get_request(agent, link)
  begin
    agent.get(HTTPS + link)
  rescue
    puts ERRMSG_GET_LINK
    puts HTTPS + link
    puts ""
  end
end

def get_child_links(agent, link, xpath)
  links = []
  page  = get_request(agent, link)
  if page
    elements = page / xpath
    elements&.each { |e| links << e.get_attribute("href") }
    # links = elements&.map { |e| e.get_attribute("href") } # linksにnilが代入されてしまう恐れがあるため不可
    # links = elements&.map(&:get_attribute("href"))        # ("href")の'()'で不可
  end
  return links, page
end


agent = Mechanize.new

links_1 = get_child_links(agent, LINK_0, XPATH_LINK_0)

links_1[0].uniq.each do |link_1|
  links_2 = get_child_links(agent, link_1, XPATH_LINK_1)

  links_2[0].each do |link_2|
    links_3 = get_child_links(agent, link_2, XPATH_LINK_2)
    page = links_3[1]

    if element_next = page&.at(XPATH_LINK_2_NEXT)
      link_next = element_next.get_attribute("href")
      links_3_add = get_child_links(agent, LINK_2_DIR + link_next, XPATH_LINK_2)
      links_3[0] += links_3_add[0]
      page = links_3_add[1]
      
      while element_next = page&.at(XPATH_LINK_2_NEXT_2)
        link_next = element_next.get_attribute("href")
        links_3_add = get_child_links(agent, LINK_2_DIR + link_next, XPATH_LINK_2)
        links_3[0] += links_3_add[0]
        page = links_3_add[1]
      end
    end

    links_3[0].each do |link_3|

      # データベースに保存する情報（コード、アーティスト名、曲名）を取得
      page = get_request(agent, link_3)
      if page
        # chord = Chord.new
        
        # chord.song = page&.at(XPATH_LINK_3_SONG).inner_text
        # song = page&.at(XPATH_LINK_3_SONG).inner_text
        # 曲名を取得
        song = page.at(XPATH_LINK_3_SONG)
        song ||= page.at(XPATH_LINK_3_SONG_2)
        
        song_text = song.inner_text.slice(1..) if song_text

        #アーティスト名を取得
        # credits = page.at(XPATH_LINK_3_CREDITS).inner_text
        # # chord.artist = credits.split("/")[0].slice(2..)
        # artist = credits.split("/")[0].slice(2..)
        # artist = links_1[1].at()

        # chord.chord1st = page&.at(XPATH_LINK_3_CHORDS).inner_text
        # chord1st = page.at(XPATH_LINK_3_CHORDS).inner_text
  
        # chord.save
      end
    end
  end
end


require 'mechanize'

HTTPS               = "https:"
LINK_0              = "//music.j-total.net/sp/as/"
LINK_2_DIR          = "//music.j-total.net/dbsp/"
ERRMSG_GET_LINK     = "GETリクエストエラー発生"
XPATH_LINK_0        = "/html/body/table[4]/tr/td/div/a"
XPATH_LINK_1        = "/html/body/ul[3]/li/a"
XPATH_LINK_2        = "/html/body/table[6]/tr/td/div/form/p/a[@target='_blank']"
XPATH_LINK_2_NEXT   = "/html/body/center[3]/font/a"
XPATH_LINK_2_NEXT_2 = "/html/body/center[3]/font/a[2]"

def get_child_links(agent, link, xpath)
  links = []
  page  = nil
  begin
    page = agent.get(HTTPS + link)
  rescue
    puts ERRMSG_GET_LINK
    puts HTTPS + link
    puts ""
  end
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
      links_4 = []
      page = nil
      begin
        page = agent.get(HTTPS + link_3)
      rescue
        puts ERRMSG_GET_LINK
        puts HTTPS ################## link_3
        puts ""
      end
      if page
        elements = page / xpath
        elements&.each { |e| links << e.get_attribute("href") }
        # links = elements&.map { |e| e.get_attribute("href") } # linksにnilが代入されてしまう恐れがあるため不可
        # links = elements&.map(&:get_attribute("href"))        # ("href")の'()'で不可
      end
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
 
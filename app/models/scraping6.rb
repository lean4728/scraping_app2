require 'mechanize'

HTTPS                  = 'https:'
LINK_0_DIR             = '//music.j-total.net/sp/as/'
LINK_2_DIR             = '//music.j-total.net/dbsp/'
ERRMSG_GET_REQ         = 'GETリクエストエラー発生'
XPATH_LINK_0           = '/html/body/table[4]/tr/td/div/a'
XPATH_LINK_1           = '/html/body/ul[3]/li/a'
XPATH_LINK_2           = '/html/body/table[6]/tr/td/div/form/p/a[@target=""]'
XPATH_LINK_2_NEXT      = '/html/body/center[3]/font/a'
XPATH_LINK_2_NEXT_2    = '/html/body/center[3]/font/a[2]'
# XPATH_LINK_3_SONG      = '/html/body/table[4]/tr/td[1]/table/tr/td/table/tr[1]/td[1]/font/b'
# XPATH_LINK_3_SONG_2    = '/html/body/div[3]/div[1]/div[1]/h1'
XPATH_LINK_3_CREDITS   = '/html/body/table[4]/tr/td[1]/table/tr/td/table/tr[1]/td[2]/font'
XPATH_LINK_3_CREDITS_2 = '/html/body/div[3]/div[1]/div[1]/h2'
XPATH_LINK_3_CHORDS    = '/html/body/div[3]/div[1]/p[1]/tt/a'

# 指定リンクにGETリクエスト
# エラーの場合、エラーメッセージ出力
def get_request(agent, link)
  uri = link.start_with?('https:') ? link : HTTPS + link
  agent.get(uri)
rescue
  puts ERRMSG_GET_REQ
  puts uri
  puts ''
end

# 指定XPathのリンクを配列で取得
def get_child_links(page, xpath)
  links      = []
  links_text = []
  if page
    elements = page / xpath
    elements&.each { |e|
      links      << e.get_attribute('href')
      links_text << e.inner_text
    }
  end
  return links, links_text
end


agent = Mechanize.new

# アーティスト別検索ページから、あいうえお順検索結果ページのリンクを取得
page = get_request(agent, LINK_0_DIR)
links_1 = get_child_links(page, XPATH_LINK_0)

links_1[0].uniq.each do |link_1|
  # あいうえお順検索結果ページから、アーティスト名検索結果ページのリンクを取得
  page = get_request(agent, link_1)
  links_2 = get_child_links(page, XPATH_LINK_1)
  
  links_2[0].each_with_index do |link_2, index_links_2|
    # アーティスト名検索結果ページから、楽曲コード譜ページのリンクを取得
    page = get_request(agent, link_2)
    links_3 = get_child_links(page, XPATH_LINK_2)
    
    # 次ページのリンクがある場合、次ページから楽曲コード譜ページのリンクを追加で取得
    if element_next = page&.at(XPATH_LINK_2_NEXT)
      link_next = element_next.get_attribute('href')
      page = get_request(agent, LINK_2_DIR + link_next)
      links_3_add = get_child_links(page, XPATH_LINK_2)
      links_3[0] += links_3_add[0]
      links_3[1] += links_3_add[1]
      
      while element_next = page&.at(XPATH_LINK_2_NEXT_2)
        link_next = element_next.get_attribute('href')
        page = get_request(agent, LINK_2_DIR + link_next)
        links_3_add = get_child_links(page, XPATH_LINK_2)
        links_3[0] += links_3_add[0]
        links_3[1] += links_3_add[1]
      end
    end

    links_3[0].each_with_index do |link_3, index_links_3|
      # 楽曲コード譜ページから、データベースに保存する情報（曲名、アーティスト名、コード）を取得
      page = get_request(agent, link_3)
      if page
        # chord = Chord.new
        
        # 曲名を取得
        song = links_3[1][index_links_3]
        # element_song = page.at(XPATH_LINK_3_SONG)
        # element_song ||= page.at(XPATH_LINK_3_SONG_2)
        # song = element_song.inner_text&.slice(1..) if element_song

        # アーティスト名を取得
        artist = links_2[1][index_links_2].lstrip.delete("\n")
        # element_credits = page.at(XPATH_LINK_3_CREDITS)
        # element_credits ||= page.at(XPATH_LINK_3_CREDITS_2)
        # artist ||= element_credits.inner_text.split('/')[0].slice(2..) if element_credits
        puts artist

        # chord.chord1st = page&.at(XPATH_LINK_3_CHORDS).inner_text
        chord1st = page.at(XPATH_LINK_3_CHORDS)

        # chord.save
      end
    end
  end
end

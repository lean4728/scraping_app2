require 'mechanize'
require 'activerecord-import'

# class Scraping7 < ApplicationRecord

HTTPS                 = 'https:'
LINK_0_DIR            = '//music.j-total.net/sp/as/'
LINK_2_DIR            = '//music.j-total.net/dbsp/'
ERRMSG_GET_REQ        = 'GETリクエストエラー発生'
XPATH_LINK_0          = '/html/body/table[4]/tr/td/div/a'
XPATH_LINK_1          = '/html/body/ul[3]/li/a'
XPATH_LINK_2          = '/html/body/table[6]/tr/td/div/form/p/a[@target=""]'
XPATH_LINK_2_NEXT     = '/html/body/center[3]/font/a'
XPATH_LINK_2_NEXT_2   = '/html/body/center[3]/font/a[2]'
# XPATH_LINK_3_CHORDS   = '/html/body/table[4]/tr/td[1]/table/tr/td/table/tr[2 or 3]/td/table/tr/td/div/div[2]/tt/a'
# XPATH_LINK_3_CHORDS   = '/html/body/table[4]/tr/td[1]/table/tr/td/table/tr[3]/td/table/tr/td/tt/a'
XPATH_LINK_3_CHORDS   = '/html/body/table[4]/tr/td[1]/table/tr/td/table/tr[2 or 3]/td/table/tr/td//tt/a'
# XPATH_LINK_3_CHORDS_2 = '/html/body/div[3]/div[1]/p[1]/tt/a'
# XPATH_LINK_3_CHORDS_2 = '/html/body/div[3]/div[1]/tt/a'
XPATH_LINK_3_CHORDS_2 = '/html/body/div[3]/div[1]//tt/a'

# 指定リンクにGETリクエスト
# エラーの場合、エラーメッセージ出力
def get_request(agent, link)
  url = link.start_with?('https:') ? link : HTTPS + link
  url = url.delete("\n")
  agent.get(url)
rescue
  puts ERRMSG_GET_REQ
  puts url
  puts ''
end

# 指定XPathのリンクを配列で取得
def get_child_links(page, xpath)
  links      = []
  links_text = []
  if page
    elements = page / xpath
    elements&.each { |e|
      links      << e[:href]
      links_text << e.inner_text
    }
  end
  return links, links_text
end
# end

# def self.scrape
agent = Mechanize.new
    
    # アーティスト別検索ページから、あいうえお順検索結果ページのリンクを取得
    page = get_request(agent, LINK_0_DIR)
    links_1 = get_child_links(page, XPATH_LINK_0)
    
    links_1[0][0..1].uniq.each do |link_1|
      # あいうえお順検索結果ページから、アーティスト名検索結果ページのリンクを取得
      page = get_request(agent, link_1)
      links_2 = get_child_links(page, XPATH_LINK_1)
      
      links_2[0][0..1].each_with_index do |link_2, index_links_2|
        chords = []
        
        # アーティスト名検索結果ページから、楽曲コード譜ページのリンクを取得
        page = get_request(agent, link_2)
        links_3 = get_child_links(page, XPATH_LINK_2)
        
        # 次ページのリンクがある場合、次ページから楽曲コード譜ページのリンクを追加で取得
        if element_next = page&.at(XPATH_LINK_2_NEXT)
          link_next = element_next[:href]
          page = get_request(agent, LINK_2_DIR + link_next)
          links_3_add = get_child_links(page, XPATH_LINK_2)
          links_3[0] += links_3_add[0]
          links_3[1] += links_3_add[1]
          
          while element_next = page&.at(XPATH_LINK_2_NEXT_2)
            link_next = element_next[:href]
            page = get_request(agent, LINK_2_DIR + link_next)
            links_3_add = get_child_links(page, XPATH_LINK_2)
            links_3[0] += links_3_add[0]
            links_3[1] += links_3_add[1]
          end
        end
        
        links_3[0][0..1].each_with_index do |link_3, index_links_3|
          # 楽曲コード譜ページから、データベースに保存する情報（曲名、アーティスト名、コード）を取得
          page = get_request(agent, link_3)
          if page
            # 曲名を取得
            #chord.song = links_3[1][index_links_3]
            song = links_3[1][index_links_3]
            
            # アーティスト名を取得
            artist_lines = links_2[1][index_links_2]
            artist = ''
            artist_lines.each_line { |l| artist += l.lstrip }
            # chord.artist = artist.delete("\n")
            artist = artist.delete("\n")
            
            # chord = Chord.new
            # chord = Chord.where(song: song, artist: artist).first_or_initialize
            
            # 楽曲コード譜ページURLを取得
            # chord.chord2nd = page.uri
            puts chord2nd = page.uri.to_s

            puts "#{DateTime.now.minute}:#{DateTime.now.second}"
            
            chord1st = page / XPATH_LINK_3_CHORDS
            chord1st = page / XPATH_LINK_3_CHORDS_2 if chord1st.empty?
            if chord1st.empty?
              puts "\n\n\n******************\n\n\nコード無い\n#{link_3}\n\n\n******************\n\n\n"
            end
            # puts chord.chord1st = chord1st.inner_text
            puts chord1st = chord1st.inner_text
            
            # chords << chord
            # chord.save
          end
        end
        # Chord.import chords
      end
    end
  # end
  

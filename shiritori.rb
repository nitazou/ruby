# coding: utf-8
require 'mechanize'
require "rexml/document"
require 'MeCab'
require "moji"

#読み仮名を取得関数
def get_yomi word
  word.slice! "ー"
  mecab = MeCab::Tagger.new("-Oyomi")

  katakana= mecab.parse(word)
  #puts katakana

  hiragana =Moji.kata_to_hira(katakana.toutf8) 
  
  hiragana.chomp!
  return hiragana
end

#最後の文字（ひらがな）取得関数
def get_last_word word
  return word[word.length-1]
end

agent = Mechanize.new

#初期値
suggest_list=["魚"]
suggest_list_kana=[]
yomi= get_yomi suggest_list[0]
suggest_list_kana[0] =yomi

19.times do |i|

 #p i
 puts suggest_list[i]
 puts suggest_list_kana[i]

 #サジェスト文字作成
 suggest_q = get_last_word suggest_list_kana[i]

 #p "q="+suggest_q

 #googleから候補をXMLで取得
 suggest=agent.get('http://google.co.jp/complete/search?output=toolbar&hl=ja&q=' + suggest_q)
 #puts suggest.body.toutf8


 #XMLを解析する準備
 source=suggest.body.toutf8
 doc = REXML::Document.new source
 #puts doc

 #XMLパースし、読み仮名を取得
 doc.elements.each('toplevel/CompleteSuggestion/suggestion') do |element|
  #p element.attributes["data"]
  suggest_list << element.attributes["data"]
  yomi = get_yomi suggest_list[i+1]
  #p yomi
  suggest_list_kana << yomi
  break
 end


 #sleep 1

end




# coding: utf-8
require 'mechanize'
require "rexml/document"
require 'MeCab'
require "moji"




#読み仮名を取得関数
def get_yomi word

  mecab = MeCab::Tagger.new("-Oyomi")

  katakana= mecab.parse(word)
  #puts katakana

  hiragana =Moji.kata_to_hira(katakana.toutf8) 
  
  hiragana.chomp!
  return hiragana
end

#最後の文字（ひらがな）取得関数
def get_last_word word
	  word.slice! "ー"
  return word[word.length-1]
end


#サジェスト取得
def get_suggest suggest_q
 #googleから候補をXMLで取得
 agent = Mechanize.new
 suggest=agent.get('http://google.co.jp/complete/search?output=toolbar&hl=ja&q=' + suggest_q)
 #puts suggest.body.toutf8


 #XMLを解析する準備
 source=suggest.body.toutf8
 doc = REXML::Document.new source
 #puts doc

 #XMLパースし、読み仮名を取得
 doc.elements.each('toplevel/CompleteSuggestion/suggestion') do |element|
  #p element.attributes["data"]
   yomi=get_yomi element.attributes["data"]
   last_word=get_last_word yomi
   #p yomi
   end_check=get_end_check last_word
   if end_check==1
    
    else
    	return element.attributes["data"]
      break
   end
 end
end


#終わりチェック
def get_end_check word
 #puts word
 if word=="ん"
 	return 1
 else
 	return 0
 end
end

#初期値
suggest_list=["魚"]
suggest_list_kana=[]
yomi= get_yomi suggest_list[0]
suggest_list_kana[0] =yomi

char_set=[*'あ'..'ん']



50.times do |i|

 #p i
 puts suggest_list[i]
 #puts suggest_list_kana[i]

 #サジェスト文字作成
 suggest_q = get_last_word suggest_list_kana[i]

 end_check=get_end_check suggest_q

 if end_check==1
 	puts "END"
 	break
 end

 suggest_result=0

 #過去に出たキーワードをチェック
 loop do
  daburi_flag=0
  suggest_result=get_suggest suggest_q

  #p suggest_result
  suggest_list.each do |sl|
   if sl==suggest_result
    daburi_flag=1
    suggest_q += char_set.sample(1).join(" ")
    #puts suggest_q
    break
   end
  end

  if daburi_flag==0
   break
  end
 end

 suggest_list << suggest_result

 yomi = get_yomi suggest_list[i+1]
 suggest_list_kana << yomi

 #sleep 1

end




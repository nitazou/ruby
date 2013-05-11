# coding: utf-8
require 'mechanize'
require "rexml/document"
#require 'moji'

agent = Mechanize.new

word=["さか"]
suggest_list=[]
suggest_list_kana=[]

1.times do |i|

 #漢字の読み方を取得
 suggest=agent.get('http://yomi.harmonicom.jp/yomi.php?ic=UTF-8&oc=UTF-8&k=h&n=1&t=' + word[i])
 word_last=suggest.body.toutf8
 p word_last

 p i

 case word_last[word_last.length-1]
  when "ー"
   #最後が-だったら最後から２文字前の文字を使う
   word_last = word_last[word_last.length-2]
  else
   #単語の最後の文字を取得
   word_last = word_last[word_last.length-1]
 end 

 #んがついたら終わり
 if word_last=="ん"
  puts "end"
  break
 end

 #googleから候補をXMLで取得
 suggest=agent.get('http://google.co.jp/complete/search?output=toolbar&hl=ja&q=' + word_last)
 #puts suggest.body.toutf8

 #XMLを解析する準備
 source=suggest.body.toutf8
 doc = REXML::Document.new source
 #puts doc

 #XMLから候補を取得し、かなも取得する
 doc.elements.each('toplevel/CompleteSuggestion/suggestion') do |element|
  suggest_list << element.attributes["data"]
  suggest=agent.get('http://yomi.harmonicom.jp/yomi.php?ic=UTF-8&oc=UTF-8&k=h&n=1&t=' + element.attributes["data"])
  suggest_list_kana << suggest.body.toutf8
 end


 #小文字やーを削除する
 10.times do |i|
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ー","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ぁ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ぃ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ぅ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ぇ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ぉ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("っ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ゃ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ゅ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ょ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ゎ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ァ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ィ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ゥ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ェ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ォ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ッ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ャ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ュ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ョ","")
  suggest_list_kana[i]=suggest_list_kana[i].gsub("ヮ","")
 end

 puts suggest_list 
 puts suggest_list_kana
 suggest_list.clear
 suggest_list_kana.clear

 #start_text = suggest.body.index("data=""") 
 #end_text = suggest.body.index("""/>") 
 #result=suggest.body[start_text+6..end_text-2].toutf8

 #word<<result

 #puts word

end




# coding: utf-8
require 'mechanize'
require 'MeCab'

def last_word word
  word.slice! "ー"
  mecab = MeCab::Tagger.new
  result = String.new
  node = mecab.parseToNode word
  while node.next.next
    node = node.next

    puts "#{node.feature}"

  end
  /([^,]*),[^,]*?$/ =~ node.feature
  $1[-1]

end

agent = Mechanize.new

word=["しりとー"]

2.times do |i|

 p i
 word_last = last_word word[i]

 p word_last


 #googleから候補をXMLで取得
 suggest=agent.get('http://google.co.jp/complete/search?output=toolbar&hl=ja&q=' + word_last)
 #puts suggest.body.toutf8

 start_text = suggest.body.index("data=""") 
 end_text = suggest.body.index("""/>") 
 result=suggest.body[start_text+6..end_text-2].toutf8

 word<<result

 puts result
 #sleep 1

end




# coding: utf-8
require 'mechanize'

agent = Mechanize.new

word=["しりとり"]

15.times do |i|

 p i
 word_last = word[i]
 word_last = word_last[word_last.length-1]

 if word_last=="ー"
  word_last = word[i]
  word_last = word_last[word_last.length-2]
 end 

 p word_last


 suggest=agent.get('http://google.co.jp/complete/search?output=toolbar&hl=ja&q=' + word_last)
 #puts suggest.body.toutf8

 start_text = suggest.body.index("data=""") 
 end_text = suggest.body.index("""/>") 
 result=suggest.body[start_text+6..end_text-2].toutf8

 word<<result

 puts result
 sleep 1
end




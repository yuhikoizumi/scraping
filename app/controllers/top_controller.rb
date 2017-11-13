class TopController < ApplicationController
  require 'mechanize'
  def index 
    agent = Mechanize.new
    page = agent.get('https://www.j-anshin.co.jp/list_todokede/search_list.php?mode=hokenbetsu&todoufuken=&trader=&reform_flg=1&p=1')
    @data = page.search('.ulDotList li p').inner_text
    puts @data.first
  end

  def new
    
  end

end

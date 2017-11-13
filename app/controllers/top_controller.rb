class TopController < ApplicationController
  require 'mechanize'
  def index 
    agent = Mechanize.new
    # (1..141).each do |i|
    #   page = agent.get("https://www.j-anshin.co.jp/list_todokede/search_list.php?mode=hokenbetsu&todoufuken=&trader=&reform_flg=1&p=#{i}").click
        # time.sleep(10)
    #   page = agent.get("https://www.j-anshin.co.jp/list_todokede/search_list.php?mode=hokenbetsu&todoufuken=&trader=&reform_flg=1&p=#{i + 1}").click
    # end
    @data = page.search('.ulDotList li p')
  end

  def new
    
  end

end

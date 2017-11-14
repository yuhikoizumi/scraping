class TopController < ApplicationController
  require 'mechanize'
  require 'csv'
  def index 
    agent = Mechanize.new
    (1..141).each do |n|
      page = agent.get("https://www.j-anshin.co.jp/list_todokede/search_list.php?mode=hokenbetsu&todoufuken=&trader=&reform_flg=1&p=#{n}")
      @data = page.search('.ulDotList li p').text
      b = @data.gsub("リフォーム保険：","&&&&")
      c = b.chomp
      d = c.gsub("保険付保実績数"," ").split(" ")
      f = d.select{ |x| x.include?("対象") == false }
      arr = []
      number = [] if n == 1
      if number.empty?
        num = 0
      else
        num = number.inject(:+)
      end
      f.each.with_index(1) do | x,i |
        if x.include?("&&&&") or i == 1
          num += 1
          var = "@box#{num}"
          eval("#{var} = {}")
          if i == 1
            eval("@box#{num}#{["NAME"]}= x")
            arr << eval("#{var}")
          end
          if x.include?("&&&&")
            arr << eval("#{var}")
          end
          next
        else
          if x.include?("〒")
            zip = x.delete!("〒")
            eval("@box#{num}#{["zip_code"]}= zip")
            @vpp = i
          elsif x.include?("TEL")
            tel = x.delete!("TEL：")
            eval("@box#{num}#{["TEL"]}= tel")
          elsif x.include?("FAX")
            fax = x.delete!("FAX：")
            eval("@box#{num}#{["FAX"]}= fax")
          elsif x.include?("E-mail")
            fax = x.slice!("E-mail：")
            eval("@box#{num}#{["E-mail"]}= x")
          elsif i == @vpp + 1
            eval("@box#{num}#{["ADDRESS"]}= x")
          else
             eval("@box#{num}#{["NAME"]}= x")
          end
        end
        if i == f.length
          number << f.length
        end
      end
      sleep(10)
    end
    download_csv(arr)
  end

  def download_csv(arr)
    header = ['会社名', '郵便番号', '住所','TEL','FAX','アドレス']
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      arr.each do |q|
        csv << [q["NAME"],q["zip_code"],q["ADDRESS"],q["TEL"],q["FAX"],q["E-mail"]]
      end
    end
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: 'record.csv',
      type: 'text/csv; charset=shift_jis'
  end

end

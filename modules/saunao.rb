require 'net/http'
require 'json'

module Kisaki
  class Saunao
    def initialize(api_key)
      @saucenao = "https://saucenao.com/search.php?db=999&api_key=#{api_key}&output_type=2&numres=1&url="
    end

    def search(url)
      pp uri = @saucenao+url
      search_result = parse_result(get(uri,{}))
      return search_result
    end

    def parse_result(result)
      pp result["results"][0]
      if result["results"][0]["header"]["similarity"].to_i > 80 and result["results"][0]["header"]["index_id"] == 5
        output = "画师:#{result["results"][0]["data"]["member_name"]}[#{result["results"][0]["data"]["member_id"]}]\npid:#{result["results"][0]["data"]["pixiv_id"]}"
        return output
      end
      return "没有找到相关信息\n（本功能暂时仅支持pixiv）"
    end

    def get uri,data
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(req)
      return JSON.parse(res.body)
    end
    private :get
  end
  
  def saunao 
    @sev["messageChain"].each do |msg|
      if msg["type"] == "Quote"
        qmsg = @@bot.messageFromId(msg["id"])
        if qmsg["code"] == 0
          saunao_qmsgsolv(qmsg["data"]["messageChain"])
        end
      end #of if Quote

      if msg["type"] == "Image"
        saunao_imgsolve(msg["url"])
      end #of if Image

    end #of each msg
  end #of saunao
  
  def saunao_qmsgsolv(qmsg)
    qmsg.each do |msg|
      if msg["type"] == "Image"
        text = @saucenao.search(msg["url"])
        @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>text}]
      end
    end
  end# of saunao_qmsgsolv

  def saunao_imgsolve(imgurl)
    text = @saucenao.search(imgurl)
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>text}]
  end
end
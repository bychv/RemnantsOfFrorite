require 'net/http'
require 'open-uri'
require 'json'


module Kisaki
  def kkp
    pp "kkp"
    @pixivsource = "https://api.lolicon.app/setu/v2"
    @pixivproxy = "i.pixiv.re"
    @pretags = ["萝莉","少女","黑丝","白丝","百合","伪娘",'眼镜娘',"正太" ]
    pixivsource = @pixivsource
    pixivproxy = @pixivproxy
    pretags = @pretags
    tag = ""
    pretags.each do |ptag|
      if /#{ptag}/ =~ @smsg['text']
        tag = ptag  
        break
      end
    end # of each_do
    pixiv_api_arg = {
      "tag"=>tag,
      "proxy"=>pixivproxy,
      "size" => "regular"
    }
    apiresp = Hash.new
    t1 = Thread.new do
    apiresp = httppost pixivsource,pixiv_api_arg
    end
    t1.join()
    pp apiresp["data"][0]["tags"]
    picurl = apiresp["data"][0]["urls"]["regular"]
    pp picurl,tag
    Async do
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>picurl }]
    end
  end #of kkp
  
  def kkpabout
    tags = @pretags.join("->")
    kkptag = "kkp tag:#{tags}"
    kkps = "Pixiv api:#{@pixivsource}\n"
    kkpp = "Pixiv proxy:#{@pixivproxy}\n"
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>kkps+kkpp+kkptag }]
  end
  
  def httppost uri,data
    uri = URI.parse uri
    datajson = JSON.generate(data)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, 
      'Content-Type' => 'application/json')
    request.body = datajson
    resp = http.request(request)
    return JSON.parse(resp.body)
  end
end

require 'net/http'
require 'open-uri'
require 'json'


module Kisaki
  def kkpinit
    @pixivsource = "https://api.lolicon.app/setu/v2"
    @pixivproxy = "piximg.lowwevx.link" #"i.pixiv.re"
    @pretags = ["萝莉","少女","黑丝","白丝","百合",'泳装',"伪娘",'眼镜娘',"白发","银发","黑发","兽耳","猫娘","东方" ]
  end

  def kkp
    pp "kkp"
  
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
    begin
    apiresp = httppost pixivsource,pixiv_api_arg
    rescue
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"#{$!}" }]
      return
    end
    pp apiresp["data"][0]["tags"]
    picurl = apiresp["data"][0]["urls"]["regular"]
    picauthor =  apiresp["data"][0]["author"]
    pictitle = apiresp["data"][0]["title"]
    picpid = apiresp["data"][0]["pid"]
    pp picurl,tag
    Async do
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>picurl }]
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"以下是作者和pid\n#{picauthor}:[#{picpid}]" }]
    end
  end #of kkp
  
  def kkpabout
    tags = @pretags.join("->")
    kkptag = "kkp tag:#{tags}"
    kkps = "Pixiv api:#{@pixivsource}\n"
    kkpp = "Pixiv proxy:#{@pixivproxy}\n"
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>kkps+kkpp+kkptag }]
  end
  
  def pkp
    if not (@@smsg['text'] =~ /\/pkp(\s)+(.+)/)
      return
    end
    pixivsource = @pixivsource
    pixivproxy = @pixivproxy
    tag = $2
    pp tag = tag.split("&")
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
    begin
      picurl = apiresp["data"][0]["urls"]["regular"]
      picauthor =  apiresp["data"][0]["author"]
      pictitle = apiresp["data"][0]["title"]
      picpid = apiresp["data"][0]["pid"]
      msgcc = [
        # {
        # "type"=>"Quote",
        # "id"=> @sev["messageChain"][0]["id"],
        # "groupId"=>@sev["sender"]["group"]["id"],
        # "targetId"=>@sev["sender"]["group"]["id"],
        # "senderId"=>@sev["sender"]["id"],
        # "origin"=>@sev["messageChain"]
        # },
        { "type"=>"Image", "url"=>picurl }]
      pp @sev["messageChain"][0]["id"]
      
    rescue
      if DEBUG
        pp $!
      end
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>'not found'}]
      return
    end
    
    Async do
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],msgcc
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"以下是作者和pid\n#{picauthor}:[#{picpid}]" }]
    end

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

  def hcy_search query
    uri = URI.parse('https://api.acgmx.com/public/search')
    uri.query = 
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri, 
      'token'=>@kskconf['hcy_token'],
      'Content-Type' => 'application/json')
    request.body = datajson
    resp = http.request(request)
    return JSON.parse(resp.body)
  end
end


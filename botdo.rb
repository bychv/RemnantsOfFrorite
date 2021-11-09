require 'net/http'
require 'async'

class Botdo
  def initialize bot,msg,smsg
    @bot = bot
    @msg = msg 
    @smsg = smsg
  end


  def grpmsghadle 
    picsource = "https://acg.toubiec.cn/random.php"
    
    if @smsg["text"] =~ /kkp/
      pp @msg["sender"]["group"]["id"]
      begin 
        #bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>n.to_s }]
          Async do |task|
            task.async do 
              @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>picsource }]
            end
          end
      end
    end
    if @smsg["text"] == "/picsource" 
      pp @msg["sender"]["group"]["id"]
      begin 
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>picsource }]
      end
    end

    
  end

  def imagedl uri,imgid
    imgid =~ /\{(.*)\}/ 
    fname = "./img/"+$1 + ".jpg"
    #Async do |task|
      #task.async do
        uri = URI.parse(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri, 
        "User-Agent"=>"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0")
        pp resp = http.request(request)
        imgFile = File.new fname,"wb"
        imgFile.syswrite resp.body
        imgFile.close
        pp fname
      #end
    #end #of async
  end #of imgdl

  #def fudu 
end #of class
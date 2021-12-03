require 'net/http'
require 'json'
require 'async'

require './bychvsec.rb'

class Botdo
  include Bychv
  def initialize bot,msg,smsg
    @bot = bot
    @msg = msg 
    @smsg = smsg
  end


  def grpmsghadle smsg = @smsg
    picsource = "https://pximg.rainchan.win/rawimg"
    pixivapi = "https://pximg.rainchan.win"
    pp smsg["text"]
    
    Async do 
    if smsg["text"] =~ /kkp/i
      pp @msg["sender"]["group"]["id"]
      begin 
        #bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>n.to_s }]
          Async do |task|
            task.async do 
              @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>Bychv.getpicsource }]
            end
          end
      rescue 
        @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s}]
      end
    end
    end #of async
    if smsg["text"] == "/picsource" 
      pp @msg["sender"]["group"]["id"]
      begin 
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>picsource }]
      end
    end

    if smsg["text"] =~ /\/fudu/
      Thread.new do
        fudu smsg
      end
    end

    if smsg["text"] =~ /^pixiv/
      Async do
        pixivimg
      end
    end

    if smsg["text"][0]  == "透"
      tt = smsg["text"]
      tt[0] = ""
      pp @msg["sender"]["group"]["id"]
      begin 
        @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>tt+"，透！！！" }]
        end
    end

    if smsg["text"] == "/about"
      rbver = "ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      pp miraiver = "mirai-http-api:"+@bot.version
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>miraiver+"\n"+rbver+"\n"}]
    end

    if smsg["text"] =~ /^(\s)*>电我.*下/
      @bot.mute @msg["sender"]["group"]["id"],@msg["sender"]["id"],60
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"电死你！"}]
    end

  end
  
  def fudu smsg 
    if smsg != @smsg then return end
    begin
    pp @msg["sender"]["group"]["id"]
    command = smsg['text'].split
    if command.size >= 3 and command[-1].to_i < 10
      n = command[-1].to_i
      command.delete_at -1
      command.delete_at 0
      str_to_sent = command.join(sep=" ")
      msga = {"type"=>"Plain","text"=>str_to_sent}
      Async do
        n.times do
          
          Async do
            @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>str_to_sent }]
            pp grpmsghadle msga
            
          end
        end # of times do
      end #of Async do 1
    end #of if

    rescue
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
    end #of begin...rescue...
  end #end of fudu
  
  def pixivimg
    begin
      id = @smsg["text"].split[1]
      url = "https://pximg.rainchan.win/imginfo?img_id="+id
      uri = URI.parse(url)
      resp = Net::HTTP.get(uri)
      pinfo = JSON.parse(resp)
      pinfo["tags"]['tags'].each do |i|
        if i['tag'] =~ /R-18/i
          @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"不许色色" }]
          return
        end
      end
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>"https://pximg.rainchan.win/img?img_id="+id.to_s }]
    rescue 
      @bot.sendGroupMessage @msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
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
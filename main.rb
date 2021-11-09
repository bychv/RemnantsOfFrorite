require 'toml-rb'
require './rubymiraihttpapi/miraihttpapi.rb'
require './botdo.rb'

path = File.join(File.dirname(__FILE__), 'config.toml')
pp config = TomlRB.load_file(path)

bot = Miraibot.new 'localhost',8080
bot.verify config['verify']


bot.bind config["bot"].to_i
bot.setAdmin config["admin"].to_i


def nudge msg,bot
  if msg["target"] == bot.qq or msg["target"] == bot.admin and msg["fromId"] != bot.qq
    bot.sendNudge msg["fromId"],msg["subject"]["id"],msg["subject"]["kind"]
  end
end

class Botgroupmsg
  @picsource = "https://acg.toubiec.cn/random.php"
  def self.msgtype msg,bot
    mscindex = 0
    
    msg["messageChain"].each do |smsg|
      botdo = Botdo.new bot,msg,smsg
      if smsg["type"] == "Plain"
        botdo.grpmsghadle
        
        #FUDU
        if smsg["text"] =~ /\/fudu/   
          pp msg["sender"]["group"]["id"]
          commandh = smsg["text"].split(pattern=" ")
          begin
            
            if   msg["sender"]["id"] != true and commandh[2].to_i > 10
              begin
                
                bot.sendGroupMessage msg["sender"]["group"]["id"],[ {"type"=>"At", "target"=>msg["sender"]["id"], "display"=>""},{ "type"=>"Plain", "text"=>" Permission Denied" }]
              rescue
                bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
              
              end
          else  
            
            begin
              ha = Array.new(commandh[2].to_i)
              commandh[2].to_i.times do |i|
                begin 
                  ha[i] = Thread.new do
                    Async do
                    bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>commandh[1] }]
                    end
                    botdo.grpmsghadle 
                  rescue
                    bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
                  end
                end
                sleep 0.5
              end
              ha.each do |i|
                #i.join
              end
              rescue
                bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
            end
          end
        rescue
          bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
        end

        end
        
      end
      #At
      if smsg["type"] == "At" and smsg["target"] == bot.qq and msg["sender"]["id"] == bot.admin
        begin
          #asw smsg[mscindex+1]["text"]
          bot.sendGroupMessage msg["sender"]["group"]["id"],[ {"type"=>"At", "target"=>msg["sender"]["id"], "display"=>""},{ "type"=>"Plain", "text"=>" 爪巴😅" }]
        rescue
          bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!.to_s }]
          
        end
      end
      mscindex += 1

      if smsg["type"] == "Image" 
        begin
          if msg["sender"]["id"] == 3492132882
          Async do
            botdo.imagedl smsg["url"],smsg["imageId"]
          end
          end
        rescue 
          pp $!
        end
        pp smsg["url"]
      end
  
    end

    

  end

  
end

def botthings bot,resp
  resp['data'].uniq!
  pp resp
  resp['data'].each do |msg|
    if msg["type"] == "NudgeEvent"
      nudge msg,bot
    end

    if msg["type"] == "GroupMessage"
      Botgroupmsg.msgtype msg,bot
    end
  end

  

end


while true
resp = bot.fetchMessage 10
resp['data'].uniq!
botthings bot,resp
sleep(0.5)
end

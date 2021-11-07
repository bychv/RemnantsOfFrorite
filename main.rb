require 'toml-rb'
require './rubymiraihttpapi/miraihttpapi.rb'


bot = Miraibot.new 'localhost',8080
bot.verify 'abc'

path = File.join(File.dirname(__FILE__), 'config.toml')
config = TomlRB.load_file(path)

bot.bind config["bot"]
bot.setAdmin config["admin"]


def nudge msg,bot
  if msg["target"] == bot.qq and msg["fromId"] != bot.qq
    bot.sendNudge msg["fromId"],msg["subject"]["id"],msg["subject"]["kind"]
  end
end

class Botgroupmsg
  def self.picture msg,bot
    msg["messageChain"].each do |smsg|
      if smsg["type"] == "Plain"
        if smsg["text"] == "kkp"
          pp msg["sender"]["group"]["id"]
          begin 
          bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>"https://www.dmoe.cc/random.php" }]
          end
        end
        if smsg["text"] == "/picsource" 
          pp msg["sender"]["group"]["id"]
          begin 
          bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"https://www.dmoe.cc/random.php" }]
          end
        
        end
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
      Botgroupmsg.picture msg,bot
    end
  end

  

end


while true
resp = bot.fetchMessage 10
resp['data'].uniq!
botthings bot,resp
sleep(0.5)
end

require "toml-rb"

require './rubymiraihttpapi/miraihttpapi.rb'

bot = Miraibot.new 'localhost',8080
bot.verify 'abc'
bot.bind 
while true
  resp = bot.fetchMessage 10
  resp['data'].uniq!
  resp['data'].each do |msg|
    if msg["type"] == "NudgeEvent"
      if msg["target"] == bot.qq and msg["fromId"] != bot.qq
        bot.sendNudge msg["fromId"],msg["subject"]["id"],msg["subject"]["kind"]
      end
    end
  end
  #pp msg
  sleep(0.5)
end







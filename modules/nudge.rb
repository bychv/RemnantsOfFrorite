require_relative 'miraihttpapi'

module Kisaki
  def onnuget bot,msg
    @lastnugetime ||=  0
    if msg["target"] == bot.qq or msg["target"] == bot.admin and msg["fromId"] != bot.qq and Time.now.to_i - @lastnugetime > 1
      bot.sendNudge msg["fromId"],msg["subject"]["id"],msg["subject"]["kind"]
      @lastnugetime =  Time.now.to_i
    end
  end
    
end
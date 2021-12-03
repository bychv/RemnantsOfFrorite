require_relative 'miraihttpapi'

module Kisaki
  def onnuget bot,msg
    if msg["target"] == bot.qq or msg["target"] == bot.admin and msg["fromId"] != bot.qq
      bot.sendNudge msg["fromId"],msg["subject"]["id"],msg["subject"]["kind"]
    end
  end
end
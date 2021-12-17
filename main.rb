require 'toml-rb'

require './modules/miraihttpapi.rb'
require './botthings'

DEBUG = false
path = File.join(File.dirname(__FILE__), 'config.toml')
pp config = TomlRB.load_file(path)

bot = Miraibot.new 'localhost',8080

bot.verify config['verify']
bot.bind config["bot"].to_i
bot.setAdmin config["admin"].to_i
things = Botthings.new bot

while true
  begin
  resp = bot.fetchLatestMessage 10
  resp['data'].uniq!
  things.msgtype resp['data']
  rescue
    pp $!
  end
end


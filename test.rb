require 'toml-rb'

require './rubymiraihttpapi/miraihttpapi.rb'
path = File.join(File.dirname(__FILE__), 'config.toml')
pp config = TomlRB.load_file(path)

bot = Miraibot.new 'localhost',8080
bot.verify config['verify']


bot.bind config["bot"].to_i
bot.setAdmin config["admin"].to_i

while true
  a = gets
  pp eval a
end



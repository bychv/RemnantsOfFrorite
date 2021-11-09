require './rubymiraihttpapi/miraihttpapi.rb'

require 'toml-rb'
require './rubymiraihttpapi/miraihttpapi.rb'


bot = Miraibot.new 'localhost',8080
bot.verify 'abc'

path = File.join(File.dirname(__FILE__), 'config.toml')
pp config = TomlRB.load_file(path)

bot.bind config["bot"].to_i
bot.setAdmin config["admin"].to_i

def test bot
  
  pp bot.getMemberInfo 621080379,2752893082

end

ha = Array.new(x)
  5.times do |i|
    ha[i] = Thread.new do
    test bot
    pp Time.now
    end
  end

ha.each do |i|
  i.join
end



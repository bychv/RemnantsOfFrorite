#Anime Girls Holding xx Books
require 'base64'
module Kisaki
  class Aghxb
    def initialize
      @resou = Hash.new
      @resou["programming"] = Dir::open("./res/aghpgb")
      @resou["jianxuan"] = Dir::open("./res/jianxuan")
    end

    def getpic
      resfolderpath = @resou["programming"].path+"/"+@resou["programming"].children.sample
      respath = resfolderpath +"/"+ Dir.open(resfolderpath).children.sample
      picfile = File.open(respath,'rb')
      pic = Base64.encode64 picfile.sysread(picfile.size)
      return pic.gsub!("\n","")
    end  

    def get_jianxuan
      respath = @resou["jianxuan"].path+"/"+@resou["jianxuan"].children.sample
      picfile = File.open(respath,'rb')
      pic = Base64.encode64 picfile.sysread(picfile.size)
      return pic.gsub!("\n","")
    end
  end

  def aghxbinit
    @aghxb = Aghxb.new
  end

  def anghxxb
    p = @aghxb.getpic
    #w = File.new("base64","w")
    #w.syswrite(p)
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "base64"=>p}]
  end
  
  def jianxuan
    if @@sev["sender"]["group"]["id"] == @rbqg or @@sev["sender"]["group"]["id"] == 621080379
      p = @aghxb.get_jianxuan
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "base64"=>p}]
    end
  end

end
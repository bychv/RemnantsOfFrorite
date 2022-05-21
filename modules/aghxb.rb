#Anime Girls Holding xx Books
require 'base64'
module Kisaki
  class Aghxb
    def initialize
      @resou = Hash.new
      @resou["programming"] = Dir::open("./res/aghpgb")
      @resou["jianxuan"] = Dir::open("./res/jianxuan")
      @resou["dingzhen"] = Dir::open("./res/yydz")
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

    def get_dingzhen
      respath = @resou["dingzhen"].path+"/"+@resou["dingzhen"].children.sample
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
    if @@sev["sender"]["group"]["id"] == @rbqg 
      nowhour = Time.now.hour.to_s
      @jxtimev[nowhour] ||= {:d=>Time.now.day,:t=>0}
      if @jxtimev[nowhour][:d] == Time.now.day 
        @jxtimev[nowhour][:t] += 1
      end
      if @jxtimev[nowhour][:d] != Time.now.day 
        @jxtimev[nowhour][:t] = 0
        @jxtimev[nowhour][:d] = Time.now.day 
      end
      p = @aghxb.get_jianxuan
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "base64"=>p}]
    end
  end

  def jxstatus
    @jxtimev[Time.now.hour.to_s] ||= {:d=>Time.now.day,:t=>0}
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=> @jxtimev.to_s}]
  end
  def clear_jx_count
    @jxtimev[Time.now.hour.to_s][:t] = 0
    jxstatus
  end

  def jianxuanad
    p = @aghxb.get_jianxuan
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "base64"=>p}]
  end
  def isrbqgad?
    if @sev["sender"]["group"]["id"] == @rbqg and @sev["sender"]["id"] == @bot.admin
      return true
    end
    return false
  end

  def dingzhen
    p = @aghxb.get_dingzhen
    #w = File.new("base64","w")
    #w.syswrite(p)
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "base64"=>p}]
  end
  def yydzok?
    if @sev["sender"]["group"]["id"] == @rbqg
      return false
    end
    true
  end
end
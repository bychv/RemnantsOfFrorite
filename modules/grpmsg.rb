require_relative 'miraihttpapi'
require 'Async'

module Kisaki
  def about 
    rbver = "ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    pp miraiver = "mirai-http-api:"+@@bot.version
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>miraiver+"\n"+rbver+"\n"+"Kisaki version:0.0.5"}]
  end

  def tou
    tt = @@smsg["text"][1...]
    pp @@sev["sender"]["group"]["id"]
    begin
        re = @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>tt+"，透！！！" }]
    rescue
    ensure
      return re
    end
  end
  def leipu
    tt = @@smsg["text"][2...]
    pp @@sev["sender"]["group"]["id"]
    begin
        re = @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>tt+"，透！！！" }]
    rescue
    ensure
      return re
    end
  end

  def dwxx #电我x下
    pp @@sev["sender"]["group"]["id"]
    @@bot.mute @@sev["sender"]["group"]["id"],@@sev["sender"]["id"],60
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"电死你！"}]
  end

  def fudu
    pp @@sev["sender"]["group"]["id"]
    @@smsg['text'] =~ /^(\s)*\/fudu(\s)*(.*)(\s)*([0-9]+)/ 
    pp @@smsg['text']
    pp torepeat = $3
    n = $5.to_i
    if torepeat =~ /^(\s)*\/fudu(\s)*(.*)(\s)*([0-9]+)/ or n > 10
      return
    end

    reh = Array.new
    asy = Async do
      trpcmd = {"type"=>"Plain", "text"=>torepeat}
      n.times do
        resp = @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>torepeat}]
        reh.push resp
        self.grpsinglemsg trpcmd
      end
    end
    #asy.wait
    return reh

  end#of fudu

  def mthds
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>Kisaki.public_methods}]
  end

  def mutemem
    pp @@sev["sender"]["group"]["id"]
    begin
    @@smsg['text'] =~ /\/mute(\s)+(\d+)(\s)+(\d+)/
    memid = $2
    time = $4
    pp @@bot.mute @@sev["sender"]["group"]["id"],memid.to_i,time
    rescue
      if DEBUG
        @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!}]
      end
      
    end
  end

  def unmutemem
    pp @@sev["sender"]["group"]["id"]
    begin
    @@smsg['text'] =~ /\/unmute(\s)+(\d+)/
    memid = $2
    
    pp @@bot.unmute @@sev["sender"]["group"]["id"],memid
    rescue
      if DEBUG
        @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>$!}]
      end
      
    end
  end

    def automute
      pp @@sev["sender"]["group"]["id"]
      sleep(99)
      begin
        pp @@bot.mute @@sev["sender"]["group"]["id"],@@sev["sender"]["id"],3600*3
      rescue
        pp $!
      end
    end

    def getmusic
      getmusichelp = <<END
#音乐 关键词
自动搜索所有源以找出来找最佳音频来源

#QQ 关键词: 搜索QQ音乐
#网易 关键词: 搜索网易云音乐
#网易电台 关键词: 搜索网易云电台，一般来说是直接选择找到的第一个节目，但是关键词可以以 “电台名称|节目名称”的格式指定电台节目
##酷狗 关键词: 搜索酷狗音乐
#千千 关键词: 搜索千千音乐（百度音乐）
      
More: https://github.com/khjxiaogu/MiraiSongPlugin/releases/tag/v1.1.7#%E8%87%AA%E5%AE%9A%E4%B9%89%E6%8C%87%E4%BB%A4
END
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>getmusichelp}]
    end


    def cmdlist
      cmdlist = String.new
      @cmdhashre.each_key do |cmd|
        cmdlist += "#{cmd}:#{@cmdhashre[cmd][:permission]}\n"
      end
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>cmdlist}]
    end
    
end

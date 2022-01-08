require_relative 'miraihttpapi'
require 'Async'

module Kisaki
  def about 
    rbver = "ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    pp miraiver = "mirai-http-api:"+@@bot.version
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>miraiver+"\n"+rbver+"\n"+"Kisaki version:0.0.3"}]
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
    pp @@bot.mute @@sev["sender"]["group"]["id"],memid,time
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
      begin
        pp @@bot.mute @@sev["sender"]["group"]["id"],@@sev["sender"]["id"],3600*3
      rescue
        pp $!
      end
    end


  
end

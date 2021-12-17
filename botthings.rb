require './modules/kisaki.rb'

class Botthings 
include Kisaki
  def initialize bot
    @bot = bot
    ksk_initialize
  end

  def msgtype msg
    @msg = msg
    msg.each do |sev|
      pp @sev = sev
      

      if sev["type"] == "NudgeEvent"
        onnuget @bot,@sev
      end
      
      if sev['type'] == "GroupMessage"
        grpmsghandle 
      end
      if sev['type'] == "MemberMuteEvent"
        unmutemember
      end
    end#of each do
    
  end#of msgtype

  def isok?()
    if @sev["sender"]["id"] == @bot.admin
      return true
    end
    return false
  end


  def grpmsghandle 
    @cmdhashsc = {
      "/about" =>{:method=>:about,:permission=>true},
      "/kkpabout"=>{:method=>:kkpabout,:permission=>true}
    }
    
    @cmdhashre = {
      "^透.*" =>{:method=>:tou,:permission=>true},
      "^(\s)*>电我.*下"=>{:method=>:dwxx,:permission=>true},
      "^(\s)*\/fudu(\s)*.*(\s)*[0-9]+$"=>{:method=>:fudu,:permission=>true},
      "(kkp)|(涩图)|(色图)"=>{:method=>:kkp,:permission=>true},
      "^\/pkp"=>{:method=>:pkp,:permission=>true},
      "^\/mute.*"=>{:method=>:mutemem,:permission=>self.isok?},
      "^\/unmute.*"=>{:method=>:unmutemem,:permission=>self.isok?}
    }
    
    @sev["messageChain"].each do |smsg|
      @smsg = smsg
      self.grpsinglemsg smsg
    end #of msgc
    
  end

  def grpsinglemsg smsg
    setvar @bot,@sev,smsg

    @cmdhashsc.each_key do |cmd|
      #pp smsg 
      if smsg["text"] =~ /^#{cmd}$/i and @cmdhashsc[cmd][:permission]
        self.send @cmdhashsc[cmd][:method]
      end #of if
    end #of cmdhashsc
    re = []
    @cmdhashre.each_key do |cmd|
      if smsg["text"] =~ /#{cmd}/i and @cmdhashre[cmd][:permission]
            re = self.send @cmdhashre[cmd][:method]
      end
    end#of cmdre
  end
  
  def unmutemember
    if @sev["member"]["id"] == @bot.admin
      pp @bot.unmute  @sev["member"]["group"]["id"],@sev["member"]["id"]
    end
  end

end #of class
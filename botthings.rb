require './modules/kisaki.rb'

class Botthings 
include Kisaki
  def initialize bot,bgm_token
    @bot = bot
    ksk_initialize bgm_token
    @lastmsg = ''
    @lastrepeatedmsg = '2'
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
      "/kkpabout"=>{:method=>:kkpabout,:permission=>true},
      "/bgmhelp"=>{:method=>:bangumi_help,:permission=>true}
    }
    
    @cmdhashre = {
      "^透.*" =>{:method=>:tou,:permission=>true},
      "^(\s)*>电我.*下"=>{:method=>:dwxx,:permission=>true},
      "^(\s)*\/fudu(\s)*.*(\s)*[0-9]+$"=>{:method=>:fudu,:permission=>true},
      "(kkp)|(涩图)|(色图)"=>{:method=>:kkp,:permission=>true},
      "^\/pkp"=>{:method=>:pkp,:permission=>true},
      "^\/mute.*"=>{:method=>:mutemem,:permission=>self.isok?},
      "^\/unmute.*"=>{:method=>:unmutemem,:permission=>self.isok?},
      "^.+牛子"=>{:method=>:automute,:permission=>!isok?},
      "^/bgmi"=>{:method=>:get_bangumi_subject,:permission=>true},
      "^/bgms"=>{:method=>:search_bangumi_subject,:permission=>true}
    }
    
    @sev["messageChain"].each do |smsg|
      @smsg = smsg
      self.grpsinglemsg smsg
    end #of msgc
    
  end

  def grpsinglemsg smsg
    setvar @bot,@sev,smsg
    if smsg["type"] == 'Source'
      @lastmsgid = @msgid
      @msgid = smsg['id']
    end
    if smsg["type"] == "Plain" and smsg['text'] == @lastmsg and @lastmsg != @lastrepeatedmsg and @lastmsgid != @msgid
    
      #Async do
        @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>@lastmsg}]
        
        @lastrepeatedmsg = @lastmsg
      #end
    end

    if smsg["type"] == "Plain"
      @lastmsg = smsg['text']
    end
    
      
    
    @cmdhashsc.each_key do |cmd|
      #pp smsg 
      if smsg["text"] =~ /^#{cmd}$/i and @cmdhashsc[cmd][:permission]
        self.send @cmdhashsc[cmd][:method]
      end #of if
    end #of cmdhashsc
    re = []
    @cmdhashre.each_key do |cmd|
      if smsg["text"] =~ /#{cmd}/i and @cmdhashre[cmd][:permission]
        Thread.new do
          re = self.send @cmdhashre[cmd][:method]
        end
            
      end
    end#of cmdre
  end
  
  def unmutemember
    if @sev["member"]["id"] == @bot.admin
      pp @bot.unmute  @sev["member"]["group"]["id"],@sev["member"]["id"]
    end
  end

end #of class
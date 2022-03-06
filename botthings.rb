require './modules/kisaki.rb'

class Botthings 
include Kisaki
  def initialize bot,bgm_token,rbqg
    @bot = bot
    ksk_initialize bgm_token,rbqg
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
      
      if sev['type'] == "GroupMessage" or sev['type']  == "GroupSyncMessage"
        grpmsghandle 
      end
      if sev['type'] == "MemberMuteEvent"
        unmutemember
      end
    end#of each do
    
  end#of msgtype  

  #permission
  def isok?()
    if @sev["sender"]["id"] == @bot.admin
      return true
    end
    return false
  end

  def isrbqg?
    if @sev["sender"]["group"]["id"] == @rbqg #and Time.now.to_i%5 == 1# or @@sev["sender"]["group"]["id"] == 621080379
      return true
    end
    false
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
      "^.+牛子"=>{:method=>:automute,:permission=>false},
      "^/bgmi"=>{:method=>:get_bangumi_subject,:permission=>false},
      "^/bgms"=>{:method=>:search_bangumi_subject,:permission=>false},
      "^/点歌"=>{:method=>:getmusic, :permission=>true},
      "^/cmdlist"=>{:method=>:cmdlist, :permission=>true},
      "^/aghxb"=>{:method=>:anghxxb, :permission=>true},
      "^/help"=>{:method=>:kskhelp, :permission=>true},
      "剑选"=>{:method=>:jianxuan,:permission=>self.isrbqg?}
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
    if smsg["type"] == "Plain" and smsg['text'] == @lastmsg and @lastmsg != @lastrepeatedmsg and @lastmsgid != @msgid and @lastmsg =~ /\S/
    
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
        #Thread.new do
          re = self.send @cmdhashre[cmd][:method]
        #end
            
      end
    end#of cmdre
  end
  
  def unmutemember
    if @sev["member"]["id"] == @bot.admin
      pp @bot.unmute  @sev["member"]["group"]["id"],@sev["member"]["id"]
    end
  end

end #of class
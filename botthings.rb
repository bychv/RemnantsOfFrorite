require './modules/kisaki.rb'


class Botthings 
include Kisaki
  def initialize bot,bgm_token,rbqg,kskconf
    @bot = bot
    ksk_initialize bgm_token,rbqg
    @lastmsg = {:plain=>'', :image=>''}
    @lastrepeatedmsg = {:plain=>'2', :image=>'3'}
    @jxtimev = Hash.new
    @kskconf = kskconf
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
    if @sev["sender"]["group"]["id"] == @rbqg #and # or @@sev["sender"]["group"]["id"] == 621080379
      nowhour = Time.now.hour.to_s
      @jxtimev[nowhour] ||= {:d=>Time.now.day,:t=>0}
      if @jxtimev[nowhour][:d] != Time.now.day 
        @jxtimev[nowhour][:t] = 0
        @jxtimev[nowhour][:d] = Time.now.day 
      end
      
      if @jxtimev[Time.now.hour.to_s][:t] < 4
        return true
      end

      
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
      "^(透).*" =>{:method=>:tou,:permission=>true},
      "^((雷普)).*" =>{:method=>:leipu,:permission=>true},
      "^(\s)*>电我.*下"=>{:method=>:dwxx,:permission=>true},
      "^(\s)*\/fudu(\s)*.*(\s)*[0-9]+$"=>{:method=>:fudu,:permission=>true},
      "(kkp)|(涩图)|(色图)|(kknd)|(can can need)"=>{:method=>:kkp,:permission=>true},
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
      "剑选|一眼丁真"=>{:method=>:jianxuan,:permission=>self.isrbqg?},
      "以赝顶真"=>{:method=>:jianxuanad,:permission=>self.isrbqgad?},
      "剑宝选集状态"=>{:method=>:jxstatus,:permission=>true},
      "^/jxcc"=>{:method=>:clear_jx_count,:permission=>self.isok?},
      "^一眼丁真"=>{:method=>:dingzhen,:permission=>self.yydzok?}
    }
    
    @sev["messageChain"].each do |smsg|
      @smsg = smsg
      self.grpsinglemsg smsg
    end #of msgc
    
  end

  def grpsinglemsg smsg
    setvar @bot,@sev,smsg
    #auto repeat
    begin
    autorepeatth = Thread.new do
    if smsg["type"] == 'Source'
      @lastmsgid = @msgid
      @msgid = smsg['id']
    end
    if smsg["type"] == "Plain" and smsg['text'] == @lastmsg[:plain] and @lastmsg[:plain] != @lastrepeatedmsg[:plain] and @lastmsgid != @msgid and @lastmsg[:plain] =~ /\S/
    
      #Async do
      thisiscmd = true
      @cmdhashsc.each_key do |cmd|
        #pp smsg 
        if smsg["text"] =~ /^#{cmd}$/i 
          thisiscmd = false
        end #of if
      end #of cmdhashsc
      re = []
      @cmdhashre.each_key do |cmd|
        if smsg["text"] =~ /#{cmd}/i 
          #Thread.new do
          thisiscmd = false
          #end
        end      
      end
      if thisiscmd 
        torepeat = @sev['messageChain'][1..]
        @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],torepeat
        
        @lastrepeatedmsg[:plain] = @lastmsg[:plain]
      end
        
        
      #end
    end

    if smsg["type"] == "Plain"
      @lastmsg[:plain] = smsg['text']
    end
    end #of thread
    end #of begin
    #auto repeat end
    
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
    autorepeatth.join()
  end
  
  
  def unmutemember
    if @sev["member"]["id"] == @bot.admin
      pp @bot.unmute  @sev["member"]["group"]["id"],@sev["member"]["id"]
    end
  end

end #of class
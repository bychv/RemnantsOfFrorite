

module Kisaki
  def helpinit
    @cmdhelp = {
      "^透.*" =>{:help=>"",:permission=>true},
      "^(\s)*>电我.*下"=>{:help=>"禁言发送者一分钟",:permission=>true},
      "^(\s)*\/fudu(\s)*.*(\s)*[0-9]+$"=>{:help=>"/fudu A n,将A复读n次（n<10）",:permission=>true},
      "(kkp)|(涩图)|(色图)"=>{:help=>"涩图",:permission=>true},
      "^\/pkp"=>{:help=>"指定标签的涩图",:permission=>true},
      "^\/mute.*"=>{:help=>"/mute s t",:permission=>false},
      "^\/unmute.*"=>{:help=>"解禁",:permission=>false},
      "^.+牛子"=>{:help=>"自动禁言",:permission=>false},
      "^/点歌"=>{:help=>"点歌帮助", :permission=>true},
      "^/aghxb"=>{:help=>"Anime Girls Holding Programming Books图", :permission=>true},
      "^/help"=>{:help=>"显示本帮助", :permission=>true}
    }
  end

  def kskhelp
    helpinit
    helpstr = "指令以正则方式呈现\n"
    @cmdhelp.each_key do |cmd|
      pp cmd
      begin
      helpstr += "/#{cmd}/:#{@cmdhelp[cmd][:help]},权限:#{@cmdhashre[cmd][:permission]}\n"
      rescue
        pp cmd
        pp $!
      end
    end
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>helpstr}]
  end

  
end
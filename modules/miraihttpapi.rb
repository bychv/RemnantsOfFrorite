require 'net/http'
require 'json'

class Miraibot

  def initialize host,port 
    @host = host
    @port = port
    @urli = "http://#{host}:#{port}"
    
    puts @urli
  end

  #setter and getter
  def qq
    @qq
    
  end
  

  def admin
    @admin
  end

  def setAdmin admin 
    @admin = admin
    pp @version = about["data"]["version"]
  end

  def version
    @version
  end

  def about
    url = @urli+"/about"
    uri = URI.parse(url)
    return get uri,{}
  end
  #认证与会话
  def verify verifyKey
    data = {:verifyKey=>verifyKey}
    uri = URI.parse(@urli+"/verify")
    resp = post uri,data
    @sessionKey = resp["session"]
    pp @sessionKey
    return resp
  end
  
  def bind qq
    @qq = qq
    if @sessionKey == "SINGLE_SESSION"
      return
    end
    data = {:sessionkey=>@sessionKey,:qq=>@qq}
    uri = URI.parse(@urli+"/bind")
    return post uri,data
  end

  def release qq
    data = {:sessionkey=>@sessionKey,:qq=>qq}
    uri = URI.parse(@urli+"/release")
    return post uri,data
  end

  #接收消息与事件
  
  def countMessage 
    uri = URI.parse(@urli+"/countMessage?sessionKey=#{@sessionKey}")
    return get uri,{}
  end

  def fetchMessage count 
    uri = URI.parse(@urli+"/fetchMessage?sessionKey=#{@sessionKey}&count=#{count}")
    return get uri,{}
  end
  
  def fetchLatestMessage count 
    uri = URI.parse(@urli+"/fetchLatestMessage?sessionKey=#{@sessionKey}&count=#{count}")
    return get uri,{}
  end

  def peekMessage count 
    uri = URI.parse(@urli+"/peekMessage?sessionKey=#{@sessionKey}&count=#{count}")
    return get uri,{}
  end

  def peekLatestMessage count 
    uri = URI.parse(@urli+"/peekLatestMessage?sessionKey=#{@sessionKey}&count=#{count}")
    return get uri,{}
  end
  
  #缓存操作
  def messageFromId id
    uri = URI.parse(@urli+"/messageFromId?sessionKey=#{@sessionKey}&id=#{id}")
    return get uri,{}
  end

  #获取好友列表
  def friendList 
    uri = URI.parse(@urli+"/friendList?sessionKey=#{@sessionKey}")
    return get uri,{}
  end

  def groupList target
    uri = URI.parse(@urli+"/groupList?sessionKey=#{@sessionKey}&target=#{target}")
    return get uri,{}
  end

  def botProfile
    uri = URI.parse(@urli+"/botProfile?sessionKey=#{@sessionKey}")
    return get uri,{}
  end

  def friendProfile target
    uri = URI.parse(@urli+"/friendProfile?sessionKey=#{@sessionKey}&target=#{target}")
    return get uri,{}
  end

  def memberProfile target,memberId
    uri = URI.parse(@urli+"/memberProfile?sessionKey=#{@sessionKey}&target=#{target}&memberId=#{memberId}")
    return get uri,{}
  end

# 消息发送与撤回

  def sendFriendMessage target,msgc
    data = {:sessionkey=>@sessionKey,:target=>target,:messageChain=>msgc}
    uri = URI.parse(@urli+"/sendFriendMessage")
    return post uri,data
  end

  def sendGroupMessage target,msgc
    data = {:sessionkey=>@sessionKey,:target=>target,:messageChain=>msgc}
    uri = URI.parse(@urli+"/sendGroupMessage")
    return post uri,data
  end

  def sendTempMessage qq,group,msgc
    data = {:sessionkey=>@sessionKey,:qq=>qq,:group=>group,:messageChain=>msgc}
    uri = URI.parse(@urli+"/sendTempMessage")
    return post uri,data
  end

  def sendNudge target,subject,kind
    data = {:sessionkey=>@sessionKey,:target=>target,:subject=>subject,:kind=>kind}
    uri = URI.parse(@urli+"/sendNudge")
    return post uri,data
  end

  def recall target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/recall")
    return post uri,data
  end

  #文件操作

  def fileList id,path="",target=nil,group=nil,qq=nil,withDownloadInfo=nil,offset=nil,size=nil  
  data = {
    :sessionKey=>@sessionKey,
    :id=>id,:path=>path,
    :target=>target,
    :group=>group,
    :qq=>qq,
    :withDownloadInfo=>withDownloadInfo,
    :offset=>offset,
    :size=>size
  }
  a = "?"
  data.each do |key,value|
    if value != nil 
      a = a+key.to_s+"="+value.to_s+"&"
    end
  end
  a[-1] = ""
  uri = URI.parse(@urli+"/file/list"+a)
  return get uri,{}
  end

  def fileInfo id,path="",target=nil,group=nil,qq=nil,withDownloadInfo=nil  
    data = {
      :sessionKey=>@sessionKey,
      :id=>id,:path=>path,
      :target=>target,
      :group=>group,
      :qq=>qq,
      :withDownloadInfo=>withDownloadInfo
    }
    a = "?"
    data.each do |key,value|
      if value != nil 
        a = a+key.to_s+"="+value.to_s+"&"
      end
    end
    a[-1] = ""
    uri = URI.parse(@urli+"/file/info"+a)
    return get uri,{}
    end

  def fileMkdir directoryName,id,path="",target=nil,group=nil,qq=nil 
    data = {
        :sessionKey=>@sessionKey,
        :id=>id,:path=>path,
        :target=>target,
        :group=>group,
        :qq=>qq,
        :directoryName=>directoryName
    }
    uri = URI.parse(@urli+"/file/mkdir")
    return post uri,data
  end

  def fileDelete id,path="",target=nil,group=nil,qq=nil
    data = {
      :sessionKey=>@sessionKey,
      :id=>id,:path=>path,
      :target=>target,
      :group=>group,
      :qq=>qq
    }
    uri = URI.parse(@urli+"/file/delete")
    return post uri,data
  end

  def fileMove id,moveTo=nil,path="",moveToPath=nil,target=nil,group=nil,qq=nil
    data = {
      :sessionKey=>@sessionKey,
      :id=>id,:path=>path,
      :target=>target,
      :group=>group,
      :qq=>qq,
      :moveTo=>moveTo,
      :moveToPath=>moveToPath
    }
    uri = URI.parse(@urli+"/file/move")
    return post uri,data
  end
  
  def fileRename id,renameTo=nil,path="",target=nil,group=nil,qq=nil, 
    data = {
      :sessionKey=>@sessionKey,
      :id=>id,:path=>path,
      :target=>target,
      :group=>group,
      :qq=>qq,
      :renameTo=>renameTo
    }
    uri = URI.parse(@urli+"/file/rename")
    return post uri,data
  end

  #多媒体内容上传 TODO


  #账号管理

  def deleteFriend target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/deleteFriend")
    return post uri,data
  end

  #群管理

  def mute target,memberId,time=0
    data = {:sessionkey=>@sessionKey,:target=>target,:memberId=>memberId,:time=>time}
    uri = URI.parse(@urli+"/mute")
    return post uri,data
  end

  def unmute target,memberId
    data = {:sessionkey=>@sessionKey,:target=>target,:memberId=>memberId}
    uri = URI.parse(@urli+"/unmute")
    return post uri,data
  end

  def kick target,memberId,msg=""
    data = {:sessionkey=>@sessionKey,:target=>target,:memberId=>memberId,:msg=>msg}
    uri = URI.parse(@urli+"/kick")
    return post uri,data
  end

  def quit target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/quit")
    return post uri,data
  end

  def muteAll target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/muteAll")
    return post uri,data
  end

  def unmuteAll target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/unmuteAll")
    return post uri,data
  end

  def setEssence target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/setEssence")
    return post uri,data
  end

  def getGroupConfig target
    data = {:sessionkey=>@sessionKey,:target=>target}
    uri = URI.parse(@urli+"/groupConfig?sessionKey=#{@sessionKey}&target=#{target}")
    return get uri,data
  end

  def setGroupConfig target,config,name,announcement,confessTalk,allowMemberInvite,autoApprove,anonymousChat
    data = {
      :sessionkey=>@sessionKey,
      :target=>target,
      :config=>config,
      :name=>name,
      :announcement=>announcement,
      :confessTalk=>confessTalk,
      :autoApprove=>autoApprove,
      :anonymousChat=>anonymousChat
    }
    uri = URI.parse(@urli+"/groupConfig")
    return get uri,data
  end

  def getMemberInfo target,memberId
    uri = URI.parse(@urli+"/memberInfo?sessionKey=#{@sessionKey}&target=#{target}&memberId=#{memberId}")
    return get uri,{}
  end

  def setMemberInfo target,memberId,name,specialTitle
    data = {
      :sessionkey=>@sessionKey,
      :target=>target,
      :memberId=>memberId,
      :info=>{
        :name=>name,
        :specialTitle=>specialTitle
      }
    }
    uri = URI.parse(@urli+"/memberInfo")
    return post uri,data
  end

  def memberAdmin target,memberId,assign
    data = {
      :sessionkey=>@sessionKey,
      :target=>target,
      :memberId=>memberId,
      :assign=>assign
    }
    uri = URI.parse(@urli+"/memberAdmin")
    return post uri,data
  end
  
  #TODO 事件处理


  #TODO 命令













  def get uri,data
    datajson = JSON.generate(data)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri, 
      'Content-Type' => 'application/json')
    request.body = datajson
    resp = http.request(request)
    return JSON.parse(resp.body)
  end

  def post uri,data
    datajson = JSON.generate(data)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, 
      'Content-Type' => 'application/json')
    request.body = datajson
    resp = http.request(request)
    return JSON.parse(resp.body)
  end
  
  

  private :get,:post
end


require 'net/http'
require 'open-uri'
require 'json'

module Kisaki
  class Bangumi
    def initialize token
      @token = "Bearer #{token}"
    end

    def bgmget(uri,query)
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri, 
      'Content-Type' => 'application/json',
      'Authorization' => @token)
      resp = http.request(request)
      return JSON.parse(resp.body)
    end

    def get_subject(id)
      respond = bgmget "https://api.bgm.tv/v0/subjects/#{id}",""
    end

    def search_subject(keyword)
      keyword = URI.encode_www_form_component keyword
      respond = bgmget "https://api.bgm.tv/search/subject/#{keyword}",""
    end
    private :bgmget
  end


  def get_bangumi_subject
    if not (@@smsg['text'] =~ /\/bgmi(\s)+(.+)/)
      return
    end
    id = $2
    res = @bangumi.get_subject id
    pp res
    
    begin
      summary = res['summary'].gsub('\r\n','\n')
      #info begin
      info = ''
      res['infobox'].each do |i|
        info += "#{i['key']}:"
        if i['value'].class == String
          info += i['value']+"\\"
        end
        if i['value'].class == Array
          i['value'].each do |v|
            info += "#{v['v']}、"
          end
        end
        info[-1] = "\n"
      end
      #info end

      text = "标题:#{res['name']}\n\n"
      text += "简介:#{summary}\n\n"
      text += "评分:#{res['rating']['score']}\n\n"
      text += "信息:\n#{info}"
    rescue
      text = 'Not Found'
      if DEBUG
        pp $!
      end
    end
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>text}]
  end

  def search_bangumi_subject
    if not (@@smsg['text'] =~ /\/bgms(\s)+(.+)/)
      return
    end
    keyword = $2
    define = {1=>'书籍',2=>'动画',3=>'音乐',4=>'游戏'}
    res = @bangumi.search_subject(keyword)
    text = String.new
    begin
      res['list'].each do |i|
        text += "#{i['name']}[#{define[i['type']]}]:#{i['id']}\n"
      end
      if res['list'].size == 0 then text = "NOT FOUND" end
    rescue
      text = 'NOT FOUND'
      if DEBUG
        pp $!
      end
    end
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>text}]
  end

  def bangumi_help
    text = <<END_OF_STRING1
使用/bgms+关键字 搜索，结果为标题：id
使用/bgmi+id 查看条目
END_OF_STRING1
    pp text
    @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{"type"=>"Plain", "text"=>text}]
  end
end
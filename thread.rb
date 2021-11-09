require 'net/http'
require 'async'

def get 
  urls = ["https://imga.archivelowa.live/img/v2-55e014aaaa5417eeabc4e96419c422c5_r.jpg",
          "https://imga.archivelowa.live/img/v2-706cb3643d2bd7a49d05a4346d26b5b5_r.jpg",
          "https://imga.archivelowa.live/img/v2-4294c78b0038fcd9928514aa29a7624c_r.jpg",
          "https://imga.archivelowa.live/img/v2-55e014aaaa5417eeabc4e96419c422c5_r.jpg",
          "https://imga.archivelowa.live/img/gPpP9fpMda2BjTIG.jpg",
          "https://imga.archivelowa.live/img/cover.jpg",
          "https://imga.archivelowa.live/img/welcome-cover.jpg"

        ]
  #Async do |task|
    i = 0
    urls.each do |uri|
    #task.async do
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri, 
      "User-Agent"=>"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0")
    resp = http.request(request)
    pp uri,Time.now
    imgFile = File.new "./img/"+i.to_s+".jpg","wb"
    imgFile.syswrite resp.body
    imgFile.close
  #end
  #end

  end
end

get  


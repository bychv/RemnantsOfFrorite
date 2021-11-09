class Botdo
  def self.grpmsghadle msg,smsg,bot,n = 1
    picsource = "https://acg.toubiec.cn/random.php"
    
    if smsg["text"] =~ /kkp/
      pp msg["sender"]["group"]["id"]
      begin 
        #bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>n.to_s }]
        n.times do 
          bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>picsource }]
        end
      end
    end
    if smsg["text"] == "/picsource" 
      pp msg["sender"]["group"]["id"]
      begin 
      bot.sendGroupMessage msg["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>picsource }]
      end
    end
    
    
  end
end
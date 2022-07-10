require 'net/http'
require 'json'

module Kisaki
  def latexredering 
    @@smsg['text'] =~ /\/latex\s*(.*)/
    ltxstr = $1
    ltxstr = URI.encode_www_form_component(ltxstr).gsub('+','%20')
    ltxurl = 'https://latex.codecogs.com/png.image?\dpi{200}'+ltxstr
    resp = @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Image", "url"=>ltxurl}]
    if resp['code'] == 500
      @@bot.sendGroupMessage @@sev["sender"]["group"]["id"],[{ "type"=>"Plain", "text"=>"Invalid Equation"}]
    end
  end
end
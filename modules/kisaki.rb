require_relative 'miraihttpapi'
require_relative 'nudge'
require_relative 'grpmsg'
require_relative 'kkp'
require_relative 'bgm'

module Kisaki
  #init module
  def ksk_initialize(bgm_token)
    kkpinit
    @bangumi = Bangumi.new bgm_token
  end

  def setvar bot,sev,smsg
    @@bot = bot
    @@sev = sev
    @@smsg = smsg
  end
end


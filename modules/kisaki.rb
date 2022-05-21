require_relative 'miraihttpapi'
require_relative 'kskhelp'
require_relative 'nudge'
require_relative 'grpmsg'
require_relative 'kkp'
require_relative 'bgm'
require_relative 'aghxb'

module Kisaki
  #init module
  def ksk_initialize(bgm_token,rbqg)
    kkpinit
    @bangumi = Bangumi.new bgm_token
    @rbqg = rbqg
    aghxbinit
    helpinit
  end

  def setvar bot,sev,smsg
    @@bot = bot
    @@sev = sev
    @@smsg = smsg
  end
end


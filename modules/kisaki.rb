require_relative 'miraihttpapi'
require_relative 'nudge'
require_relative 'grpmsg'
require_relative 'kkp'

module Kisaki
  #init module
  def ksk_initialize
    kkpinit
  end

  def setvar bot,sev,smsg
    @@bot = bot
    @@sev = sev
    @@smsg = smsg
  end
end


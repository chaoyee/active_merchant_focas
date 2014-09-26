require "active_merchant_focas/version"
require "active_merchant"

module ActiveMerchant
  module Billing
    module Integrations
      autoload :Focas, 'active_merchant/billing/integrations/focas'
    end
  end
end
require File.dirname(__FILE__) + '/focas/helper.rb'
require File.dirname(__FILE__) + '/focas/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Focas
        autoload :Helper, 'active_merchant/billing/integrations/focas/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/focas/notification.rb'

        PAYMENT_TYPE        = '0'       # 一般交易
        ENCODE_TYPE         = 'UTF-8'
        HASH_KEY            = '1qaz2wsx3edc4rfv'

        mattr_accessor :service_url
        mattr_accessor :merchant_id
        # mattr_accessor :hash_key
        mattr_accessor :terminal_id

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
            when :production
              'https://www.focas.fisc.com.tw/FOCAS_WEBPOS/online/'
            when :development
              'https://www.focas-test.fisc.com.tw/FOCAS_WEBPOS/online/'
            when :test
              'https://www.focas-test.fisc.com.tw/FOCAS_WEBPOS/online/'
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post)
          Notification.new(post)
        end

        def self.setup
          yield(self)
        end

      end
    end
  end
end

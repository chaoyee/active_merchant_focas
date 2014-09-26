#encoding: utf-8

require 'cgi'
require 'digest/sha2'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Focas
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          ### 常見介面

          # 廠商交易編號
          mapping :account, 'MerchantID'

          mapping :mer_id, 'merID' # AM common # 特店網站之代碼，如：統編。最大值為10。
          
          mapping :terminal_id, 'TerminalID'
          # 廠商交易編號
          mapping :order, 'lidm'

          # 交易金額
          mapping :amount, 'purchAmt'

          # 0: 預設為不轉入請款檔
          mapping :auto_cap, 'AutoCap'      
          # 付款完成通知回傳網址
          mapping :notify_url, 'AuthResURL' # AM common
          # 交易描述
          mapping :description, 'CurrencyNote'

          ### Focas 專屬介面

          # 交易類型
          mapping :pay_type, 'PayType'

          mapping :en_code_type, 'enCodeType'

          mapping :req_token, 'reqToken'

          def initialize(order, account, options = {})
            super
            add_field 'MerchantID', ActiveMerchant::Billing::Integrations::Focas.merchant_id
            add_field 'PayType',    ActiveMerchant::Billing::Integrations::Focas::PAYMENT_TYPE
            add_field 'enCodeType', ActiveMerchant::Billing::Integrations::Focas::ENCODE_TYPE  
          end

          def local_date(date)
            add_field 'LocalDate', date.strftime('%Y%m%d')
          end

          def local_time(date)
            add_field 'LocalTime', date.strftime('%H%M%S')
          end

          def created_at(datetime)
            add_field 'LocalDate', datetime.strftime('%Y%m%d')
            add_field 'LocalTime', datetime.strftime('%H%M%S')
          end

          def encrypted_data
            target_values = @fields.values_at('lidm','authAmt', 'MerchantID', 'TerminalID')
            target_values.insert(2, HASH_KEY )
            # ActiveMerchant::Billing::Integrations::Focas.hash_key 要在 initializer 裡設定
            target_values << @fields.values_at('local_date','local_time').join
            add_field 'reqToken', Digest::SHA256.hexdigest(target_values.join('&')).upcase
          end

        end
      end
    end
  end
end

require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Focas
        class Notification < ActiveMerchant::Billing::Integrations::Notification

          # TODO 使用查詢功能實作 acknowledge
          # Focas 沒有遠端驗證功能，
          # 而以 checksum_ok? 代替
          def acknowledge
            checksum_ok?
          end

          # status=0 且 authCode 及 xid 均非空值，才能確定成功。
          def complete?
            if (@params['status'] == '0') && 
               (@params['authCode'].present?) &&
               (@params['xid'].present?)   
              true  #付款成功
            else
              false
            end
          end

          def checksum_ok?
            raw_data = "#{status}&#{lidm}&#{hash_key}&#{auth_code}&#{auth_resp_time}&#{merchant_id}&#{terminal_id}"
            (Digest::SHA256.hexdigest(raw_data).upcase == resp_token)
          end

          # 授權結果狀態
          def status
            @params['status']
          end

          # 訂單編號
          def lidm
            @params['lidm']
          end

          # hash_key
          def hash_key
            @params['hash_key']
          end

          # 交易授權碼
          def auth_code
            @params['authCode']
          end

          # 交易時間，格式為 YYYYMMDDHHMMSS
          def auth_resp_time
            @params['authRespTime']
          end

          # 交易驗證碼
          def resp_token
            @params['respToken']
          end

          # 特店代號
          def merchant_id
            @params['MerchantID']
          end

          # 終端機編號
          def terminal_id
            @params['TerminalID']
          end

          # 錯誤代碼
          def errcode
            @params['errcode']
          end

          # Focas 的交易序號
          def xid
            @params['xid']
          end
          alias :transaction_id :xid

          # 授權金額
          def auth_amt
            @params['authAmt']
          end         

          # 特店網站之代碼，與 MerchantID 不同
          def mer_id
            @params['merID']
          end

          # 授權失敗原因
          def err_desc
            @params['errDesc']
          end

          # 信用卡末四碼
          def last_pan4
            @params['lastPan4']
          end

          # 信用卡卡別
          def card_brand
            @params['cardBrand']
          end

          # 信用卡卡號，僅回傳前六後四的卡號，其餘以＊取代。
          def pan
            @params['pan']
          end

          # 是否為分期交易，0 為一般交易。
          def pay_type
            @params['PayType']
          end

          def gross
            @params['authAmt']
          end
        end
      end
    end
  end
end

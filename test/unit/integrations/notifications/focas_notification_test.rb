require 'test_helper'

class FocasNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    ActiveMerchant::Billing::Integrations::Focas.hash_key = '1qaz2wsx3edc4rfv'
    @focas = Focas::Notification.new(http_raw_data)
  end

  def test_params
    p = @focas.params

    # assert_equal 12, p.size
    # assert_equal 'Credit_CreditCard', p['PaymentType']
    # assert_equal 'BC586977559ED305BEC4C334DFDC881D', p['CheckMacValue']
    # assert_equal '2014/04/15 15:39:38', p['PaymentDate']
    assert_equal '0', p['status']
    assert_equal '20131024T009', p['lidm']
    assert_equal '1qaz2wsx3edc4rfv', p['hash_key']
    assert_equal '887693', p['authCode']
    assert_equal '20131024141600', p['authRespTime']
    assert_equal '950876543219001', p['MerchantID']
    assert_equal '90010001', p['TerminalID']
    assert_equal '428729487F8BE0329DD08AB8CDFCE677BEA16B04298EA46F1EBFA4C1EA4146C1', p['respToken']
  end

  def test_complete?
    assert @focas.complete?
  end

  def test_checksum_ok?
    assert @focas.checksum_ok?

    # Should preserve mac value
    assert @focas.params['respToken'].present?
  end

  private

  def http_raw_data
    # Sample notification from test environment
    #"TradeAmt=2760&RtnMsg=付款成功&MerchantTradeNo=81397545579&PaymentType=Credit_CreditCard&TradeNo=1404151506342901&SimulatePaid=1&MerchantID=2000132&TradeDate=2014-04-15 15:06:34&PaymentDate=2014/04/15 15:39:38&PaymentTypeChargeFee=0&CheckMacValue=BC586977559ED305BEC4C334DFDC881D&RtnCode=1"
    "status=0&lidm=20131024T009&hash_key=1qaz2wsx3edc4rfv&authCode=887693&authRespTime=20131024141600&MerchantID=950876543219001&TerminalID=90010001&respToken=428729487F8BE0329DD08AB8CDFCE677BEA16B04298EA46F1EBFA4C1EA4146C1"
  end
end

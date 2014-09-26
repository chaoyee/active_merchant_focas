require 'test_helper'

class FocasHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
  end

  def test_check_mac_value
    @helper = Focas::Helper.new '20131024T009', '12345678'
    @helper.add_field 'lidm', '20131024T009'
    @helper.add_field 'authAmt', '200'
    @helper.add_field 'MerchantID', '950876543219001'
    @helper.add_field 'TerminalID', '90010001'
    @helper.add_field 'local_date', '20131024'
    @helper.add_field 'local_time', '141500'

    ActiveMerchant::Billing::Integrations::Focas.hash_key = '1qaz2wsx3edc4rfv'

    @helper.encrypted_data

    assert_equal '935D2F84CBEC53716F5EB643FCE88C4DB6807372061821373F98AA0A38A10C5F', @helper.fields['reqToken']
  end

end

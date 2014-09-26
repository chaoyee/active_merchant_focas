# ActiveMerchantFocas

This plugin is an active_merchant patch for Focas (財金資訊) online payment in Taiwan.
Now it supports Credit card(信用卡).

## Installation

Add this line to your application's Gemfile:

    gem 'activemerchant'
    gem 'active_merchant_focas', '>=0.0.1'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activemerchant
    $ gem install active_merchant_focas

## Usage

Create an initializer, like initializers/focas.rb. Add the following configurations depends on your settings.

``` ruby

# config/environments/development.rb
config.after_initialize do
  ActiveMerchant::Billing::Base.integration_mode = :development
end

# config/environments/production.rb
config.after_initialize do
  ActiveMerchant::Billing::Base.integration_mode = :production
end

```

``` ruby
ActiveMerchant::Billing::Integrations::Focas.setup do |focas|
  if Rails.env.development?
    focas.merchant_id = '5566183'
    focas.hash_key    = '56cantdieohyeah'
    focas.hash_iv     = '183club'
  else
    focas.merchant_id = '7788520'
    focas.hash_key    = 'adfas123412343j'
    focas.hash_iv     = '123ddewqerasdfas'
  end
end
```

## Example Usage

Now support three payment methods:

``` ruby
  # 1. Credit card
  ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_CREDIT_CARD

  # 2. ATM
  ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_ATM

  # 3. CVS (convenience store)
  ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_CVS
```

Once you’ve configured ActiveMerchantFocas, you need a checkout form; it looks like:

``` ruby
  <% payment_service_for  @order,
                          @order.user.email,
                          :service => :focas,
                          :html    => { :id => 'focas-form', :method => :post } do |service| %>
    <% service.merchant_trade_no @order.payments.last.identifier %>
    <% service.merchant_trade_date @order.created_at %>
    <% service.total_amount @order.total.to_i %>
    <% service.trade_desc @order.number %>
    <% service.item_name @order.number %>
    <% service.choose_payment ActiveMerchant::Billing::Integrations::Focas %>
    <% service.client_back_url spree.orders_account_url %>
    <% service.notify_url focas_return_url %>
    <% service.encrypted_data %>
    <%= submit_tag 'Buy!' %>
  <% end %>
```

Also need a notification action when Focas service notifies your server; it looks like:

``` ruby
  def notify
    notification = ActiveMerchant::Billing::Integrations::Focas::Notification.new(request.raw_post)

    order = Order.find_by_number(notification.merchant_trade_no)

    if notification.status && notification.checksum_ok?
      # payment is compeleted
    else
      # payment is failed
    end

    render text: '1|OK', status: 200
  end
```

## Upgrade Notes

When upgrading from 0.1.3 and below to any higher versions, you need to make the following changes:

- the notification initialize with raw post string (instead of a hash of params)
- `return_url()` should be renamed to `notify_url()` (server-side callback url).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


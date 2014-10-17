# ActiveMerchantFocas

This plugin is an active_merchant patch for Focas (財金資訊 http://www.fisc.com.tw/) online payment in Taiwan.
Now it supports Credit card(信用卡) only.

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

## Example Usage

Once you’ve configured ActiveMerchantFocas, you need a checkout form; it looks like:

``` ruby
  <% payment_service_for @order.number,
                      @preferences[:merchant_id],
                      service: :focas,
                      html: { id: 'focas-form', method: :post } do |service| %>
  <% service.lidm @order.number %>
  <% service.amount @order.total.to_i.to_s %>
  <% service.mer_id @preferences[:mer_id] %>
  <% service.terminal_id @preferences[:terminal_id] %> 
  <% service.local_date Time.now %>
  <% service.local_time Time.now %>
  <% service.client_back_url order_checkout_url(@order.id) %>
  <% service.notify_url focas_notify_order_checkout_url(@order.id, payment_method_id: @payment_method_id) if Rails.env.production? %>
  <% service.notify_url "https://127.0.0.1:3001/orders/#{@order.id}/checkout/focas_notify/#{@payment_method_id}" if Rails.env.development? %>
  <%= submit_tag 'Press to process', class: 'button' %>
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


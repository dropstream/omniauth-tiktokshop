# OmniAuth::Tiktokshop

OmniAuth OAuth2 strategy for TikTokShop

## Usage

Authorization Code Flow
https://partner.tiktokshop.com/doc/page/63fd743c715d622a338c4e5a#Back%20To%20Top

You must first register your application:
https://partner.tiktokshop.com/doc/page/63fd743e715d622a338c4e9c
https://partner.tiktokshop.com/doc/page/63fd743d715d622a338c4e69


When you register the application, you will get an 'App Key' and 'App Secret'. These need to be provided when you configure the strategy (this example assumes the values are available in environment variables):

```
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :tiktokshop, ENV['app_key'], ENV['app_secret'],
        callback_url: "https:www.yourdomain.com/auth/tiktokshop_us/callback",
        authorize_params:  { app_key: ENV['app_key'] },
        token_params: { app_key: ENV['app_key'], app_secret: ENV['app_secret'] },
        name: 'tiktokshop_us'
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-tiktokshop'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-tiktokshop

## Response Example

Expected from 3dcart:

```
{    
    "code":0,    
    "message":"success",    
    "data":{    
            "access_token":"ROW_Fw8rBwAAAAAkW03FYd09DG-9INtpw361hWthei8S3fHX8iPJ5AUv99fLSCYD9-UucaqxTgNRzKZxi5-tfFMtdWqglEt5_iCk",    
            "access_token_expire_in":1660556783,    
            "refresh_token":"NTUxZTNhYTQ2ZDk2YmRmZWNmYWY2YWY2YzkxNGYwNjQ3YjkzYTllYjA0YmNlMw",    
            "refresh_token_expire_in":1691487031,    
            "open_id":"7010736057180325637",    
            "seller_name":"Jjj test shop",    
            "seller_base_region":"ID",    
            "user_type":0    
        },    
    "request_id":"2022080809462301024509910319695C45"    
}
```


## Contributing

1. Fork it ( https://github.com/dropstream/omniauth-tiktokshop/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
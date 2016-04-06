# Zazo::Tools

### Zazo::Tools::EventDispatcher

Before configuration you should definitely setup **AWS_REGION** (e.g. us-west-1) environment variable.

``` ruby
# you need to configure component
Zazo::Tools::EventDispatcher.configure do |config|
  config.send_message_enabled = true # default
  config.queue_url = 'https://zazo-sqsworker.dev/' # required
  config.logger = Rails.logger # optional 
end

# also you can enable/disable sending messages directly
Zazo::Tools::EventDispatcher.enable_send_message!
Zazo::Tools::EventDispatcher.disable_send_message!
```

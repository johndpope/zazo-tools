# Zazo::Tools

### Zazo::Tools::EventDispatcher

Before configuration you should setup **AWS_REGION** (e.g. us-west-1) environment variable.

``` ruby
# you need to configure component
Zazo::Tools::EventDispatcher.configure do |config|
  config.send_message_enabled = true # default
  config.queue_url = 'https://sqs-worker.dev/' # required
  config.logger = Rails.logger # optional 
end

# also you can enable/disable sending messages directly
Zazo::Tools::EventDispatcher.enable_send_message!
Zazo::Tools::EventDispatcher.disable_send_message!
```

### Zazo::Tools::Logger

``` ruby
# you need to configure component
Zazo::Tools::Logger.configure do |config|
  config.local_enabled = true # default is true if rails gem in usage
  config.rollbar_enabled = true # default is true if rollbar gem in usage
  config.logstash_enabled = true # default is false
  config.logstash_host = 'logstash.dev' # required
  config.logstash_port = 9900 # required
  config.project_name = 'zazo' # required
  config.environment = 'production' # default is Rails.env if rails gem in usage
end

# usage
Zazo::Tools::Logger.info(Object, 'what happens?')
Zazo::Tools::Logger.debug(Object, 'debugging information')
Zazo::Tools::Logger.error(Object, 'something was wrong', rollbar: true)
```

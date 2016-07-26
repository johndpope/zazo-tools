# Zazo::Tools

### Zazo::Tools::EventDispatcher

Before configuration you should setup **AWS_REGION** (e.g. us-west-1) environment variable.

``` ruby
# config/initializers/zazo_event_dispatcher.rb
Zazo::Tools::EventDispatcher.configure do |config|
  config.send_message_enabled = true # default
  config.queue_url = 'https://sqs-worker.dev/' # required
  config.logger = Rails.logger # optional 
end
```

``` ruby
# also you can enable/disable sending messages directly
Zazo::Tools::EventDispatcher.enable_send_message!
Zazo::Tools::EventDispatcher.disable_send_message!
```

### Zazo::Tools::Logger

``` ruby
# config/initializers/zazo_logger.rb
Zazo::Tools::Logger.configure do |config|
  config.local_enabled = true # default is true if rails gem in usage
  config.rollbar_enabled = true # default is true if rollbar gem in usage
  config.logstash_enabled = true # default is false
  config.logstash_host = 'logstash.dev' # required
  config.logstash_port = 9900 # required
  config.project_name = 'zazo' # required
  config.environment = 'production' # default is Rails.env if rails gem in usage
end
```

``` ruby
# usage
Zazo::Tools::Logger.info(Object, 'what happens?')
Zazo::Tools::Logger.debug(Object, 'debugging information')
Zazo::Tools::Logger.error(Object, 'something was wrong', rollbar: true)
```

### Zazo::Tools::ApiController

``` ruby
# app/controllers/api_controller.rb
class class ApiController < ActionController::Base
  include Zazo::Tools::ApiController
  
  attr_reader :current_user # current_user will be passed to interactor as user
end
```

``` ruby
# app/controllers/api/v1/things_controller.rb
class Api::V1::ThingsController < ApiController
  def index
    handle_interactor(:render,
      Index.run(interactor_params))
  end

  def show
    handle_interactor(:render,
      Show.run(interactor_params(:id)))
  end

  def create
    handle_interactor([:render, result: false],
      Create.run(interactor_params(:some, :params, :you, :need)))
  end

  def update
    handle_interactor([:render, result: false],
      Update.run(interactor_params(:id, :some, :params, :you, :need)))
  end

  def destroy
    handle_interactor([:render, result: false],
      Destroy.run(interactor_params(:id)))
  end
end
```

``` ruby
# app/interactions/api/v1/things_controller/index.rb
class Api::V1::ThingsController::Index < ActiveInteraction::Base
  object :user

  def execute
    user.things
  end
end
```


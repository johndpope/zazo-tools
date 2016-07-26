# Zazo Tools

### Zazo::Controller::Interactions

``` ruby
# app/controllers/api_controller.rb
class ApiController < ActionController::Base
  include Zazo::Controller::Interactions
  
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

### Zazo::Model::Decorator

This simple component allows to decorate model with multiple decorators.

``` ruby
# app/model/user.rb
class User
  include Zazo::Model::Decorator::Decoratable

  attr_accessor :id, :name
end
```

``` ruby
# app/model/user/decorators/inspector.rb
class User::Decorators::Inspector < Zazo::Model::Decorator
  def inspect
    "user ##{id} with name #{name}"
  end
end
```

``` ruby
# app/model/user/decorators/greeter.rb
class User::Decorators::Greeter < Zazo::Model::Decorator
  def greet
    "Hello! I'm #{name}"
  end
end
```

``` ruby
user = User.new
user.id = 666
user.name = 'Bruce'

user = user.decorate_with(:inspector, :greeter)

user.greet # => "Hello! I'm Bruce"
user.inspect # => "user #666 with name Bruce"
user.model.inspect # => "#<Userd:0x007ff529d515d0 @id=666, @name=\"Bruce\">"
```

### Zazo::Middleware::RequestDocs

This rack middleware returns static files (e.g. api documentation) bypassing rails stack. It works with basic authentication and returns files from `docs` folder.
You can override default credentials (docs:password) for basic auth via `http_documentation_username` and `http_documentation_password` environment variables.

``` ruby
# config/application.rb
.....
.....
module ZazoApp
  class Application < Rails::Application
    .....
    .....
    .....
    config.middleware.insert 0, Zazo::Tools::Middleware::RequestDocs
  end
end
```

### Zazo::Tool::EventDispatcher

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

### Zazo::Tool::Logger

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
Zazo::Tools::Logger.info(Object, 'what happens?')
Zazo::Tools::Logger.debug(Object, 'debugging information')
Zazo::Tools::Logger.error(Object, 'something was wrong', rollbar: true)
```

### Zazo::Tool::Classifier

Build class by array of parts.

``` ruby
Zazo::Tool::Classifier.new([:zazo, :tool, :classifier]).klass == Zazo::Tool::Classifier # => true
```

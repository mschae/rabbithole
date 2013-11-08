# Rabbithole
[![Build Status](https://travis-ci.org/mschae/rabbithole.png)](https://travis-ci.org/mschae/rabbithole)
[![Code Climate](https://codeclimate.com/github/mschae/rabbithole.png)](https://codeclimate.com/github/mschae/rabbithole)
[![Coverage Status](https://coveralls.io/repos/mschae/rabbithole/badge.png)](https://coveralls.io/r/mschae/rabbithole)
[![Dependency Status](https://gemnasium.com/mschae/rabbithole.png)](https://gemnasium.com/mschae/rabbithole)

The idea of this gem is to mimick Resque: It can use the same worker classes and enqueueing works similar, too.
The reason is that I really like Resque and how it does things. The only problem with it is the backend. This is not what Redis is there for or any good in.

Rabbithole allows to switch from Resque to a RabbitMQ-based queueing system with ease. And it takes care of the heavy lifting.

I wrote it as part of my job with [Bleacher Report](http://bleacherreport.com), where we exceeded the scalability of Resque (or rather Redis).

Rabbithole currently only works with Rails, although I intend to make it work standalone at some point. Please note that it is WIP.

## Installation

Add this line to your application's Gemfile:

    gem 'rabbithole'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rabbithole

## Usage

### Defining jobs
When defining a job, make sure it has a `perform` method:
```ruby
class MyAwesomeJob
  def self.perform
    # do awesome things
  end
end
```

### Enqueueing jobs:
```ruby
Rabbithole.enqueue MyAwesomeJob
```

You can pass arguments to the perform method like so:
```ruby
Rabbithole.enqueue MyAwesomeJob, arg1, arg2
```

Gotchas:

* The number of arguments you pass in has to match the arity of your perform function.
* Also Hash keys will end up as strings in the perform function, even if they were passed as symbols.
* Only serializable arguments are supported. Passing in arbitrary objects will not work.

### Running jobs
You will have to invoke the binary and specify the queues you want to execute. **As opposed to resque, the queue * denotes the default queue, not all queues!**

Example:

    bundle exec rabbithole work --queues "*" cache

For further options type `rabbithole help work`.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

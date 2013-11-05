# Rabbithole
[![Build Status](https://magnum.travis-ci.com/mschae/rabbithole.png?token=HyKTvE1fxieHwUy7Yg3w&branch=master)](https://magnum.travis-ci.com/mschae/rabbithole)
[![Code Climate](https://codeclimate.com/github/mschae/rabbithole.png)](https://codeclimate.com/github/mschae/rabbithole)
[![Coverage Status](https://coveralls.io/repos/mschae/rabbithole/badge.png)](https://coveralls.io/r/mschae/rabbithole)
[![Dependency Status](https://gemnasium.com/mschae/rabbithole.png)](https://gemnasium.com/mschae/rabbithole)

The idea of this gem is to mimick Resque: It can use the same worker classes and enqueueing works similar, too.
The reason is that I really like Resque and how it does things. The only problem with it is the backend. This is not what Redis is there for any good in.

Rabbithole allows to switch from Resque to a RabbitMQ-based queueing system with ease. And it takes care of the heavy lifting.

## Installation

Add this line to your application's Gemfile:

    gem 'rabbithole'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rabbithole

## Usage

Define a job, make sure it has a `perform` method:
```ruby
class MyAwesomeJob
  def self.perform
    # do awesome things
  end
end
```

Enqueue the job:
```ruby
Rabbithole.enqueue MyAwesomeJob
```

Be done with it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

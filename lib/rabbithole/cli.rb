require 'thor'
module Rabbithole
  class CLI < Thor
    desc 'work', 'Run the rabbithole worker. It listens to jobs and executes them.'
    option :queues,      :alias => :q, :type => :array, :required => true
    option :num_workers, :alias => :n, :type => :numeric, :default => 1
    option :require,     :alias => :r, :type => :string, :default => '.'

    def work
      load_environment options[:require]
      @worker = Worker.new(options[:num_workers])
      queues = options[:queues]
      queues << Rabbithole::Connection::DEFAULT_QUEUE if queues.delete('default') || queues.delete('*')
      queues.each do |queue|
        @worker.listen_to_queue(queue)
      end

      Signal.trap("INT") { shutdown }

      @worker.join
    end


    protected
    def shutdown
      puts 'Worker shutting down gracefully...'
      Thread.new { @worker.stop_listening }
    end

    # Entirely copied from resque
    def load_environment(file)
      if File.directory?(file) && File.exists?(File.expand_path("#{file}/config/environment.rb"))
        require "rails"
        require File.expand_path("#{file}/config/environment.rb")
        if defined?(::Rails) && ::Rails.respond_to?(:application)
          # Rails 3
          ::Rails.application.eager_load!
        elsif defined?(::Rails::Initializer)
          # Rails 2.3
          $rails_rake_task = false
          ::Rails::Initializer.run :load_application_classes
        end
      elsif File.file?(file)
        require File.expand_path(file)
      end
    end
  end
end

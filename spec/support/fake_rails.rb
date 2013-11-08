class Rails
  def self.env
    'test'
  end

  def self.root
    Pathname.new(__FILE__).dirname.join('..', 'fixtures')
  end

  def self.application
    RailsFakeApp.new
  end

  class RailsFakeApp
    def self.parent_name
      'rails_fake_app'
    end
  end
end

class Rails
  def self.env
    'test'
  end

  def self.root
    Pathname.new(__FILE__).dirname.join('..', 'fixtures')
  end
end

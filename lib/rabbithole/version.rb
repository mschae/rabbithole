module Rabbithole
  VERSION_MAJOR   = 0
  VERSION_MINOR   = 0
  VERSION_RELEASE = 3
  VERSION         = [VERSION_MAJOR, VERSION_MINOR, VERSION_RELEASE].collect(&:to_s).join('.').freeze
end

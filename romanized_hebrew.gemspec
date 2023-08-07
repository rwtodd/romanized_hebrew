Gem::Specification.new do |s|
  s.name        = "romanized_hebrew"
  s.version     = "1.0.0"
  s.summary     = "Converts romanized hebrew to unicode hebrew letters."
  s.description = <<~EOF
  The romanized_hebrew gem was built to 
  convert the hebrew romanization commonly used by the 19th and 20th-century
  English occultists (e.g. Mathers, Waite, etc) into actual hebrew unicode. It
  can provide the unicode string, or a string of HTML entities.
  EOF
  s.authors     = ["Richard Todd"]
  s.email       = "rwtodd@users.noreply.github.com"
  s.files       = ['lib/romanized_hebrew.rb']
  s.homepage    = "https://github.com/rwtodd/romanized_hebrew"
  s.license     = "MIT"
end

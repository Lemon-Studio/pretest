require "calabash-cucumber"

dir = File.expand_path(File.dirname(__FILE__))
env = File.join(dir, "env.rb")

contents = File.read(env).force_encoding("UTF-8")

contents.split($-0).each do |line|

  next if line.chars[0] == "#"

  if line[/calabash-cucumber\/cucumber/, 0]
    require "calabash-cucumber/calabash_steps"
    break
  end
end

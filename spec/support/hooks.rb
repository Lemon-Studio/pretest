require 'fileutils'

Before do
  Dir.mkdir("pretest_spec")
  Dir.chdir("pretest_spec")
  @tests = Dir.pwd
end

After do
  FileUtils.rm_rf @tests
end


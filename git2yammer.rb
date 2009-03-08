#!/usr/bin/ruby
require 'rubygems'
require 'yammer4r'
require 'oauth/consumer'


yammer = Yammer::Client.new(:config => 'oauth.yml')
ref = ARGV[0]
git_dir = ARGV[1]
Dir.chdir(git_dir)

f = IO.popen("git cat-file commit #{ref}")
output = f.readlines
f.close
committer = ''
output.each do |line|
  results = line.scan(/committer .* <(.*)@/)
  if !results.empty?
    committer = results.flatten.shift
  end
end

message = output.pop
message.gsub!(/\n/, '')

repo = git_dir.scan(/.*\/(.*).git/).flatten.shift
yammer.message(:post, :body => "#{message}  (committer: #{committer}) ##{repo}")

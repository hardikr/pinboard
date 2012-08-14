require_relative "pinboard/util"
require_relative "pinboard/client"
require_relative "pinboard/post"
require 'highline/import'

if !File.exists?(Pinboard::Client::PB_AUTH_FILE)
	print "Enter your Pinboard username : "
	u = gets.chomp
	p = ask("Password: ") {|q| q.echo = false}
	pinboard = Pinboard::Client.new(:username => u, :password => p)
else
	pinboard = Pinboard::Client.new(:api_token => File.read(Pinboard::Client::PB_AUTH_FILE).strip)
end
puts pinboard.api_token
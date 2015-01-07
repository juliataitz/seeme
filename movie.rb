
#!/usr/bin/env ruby

require 'sinatra'
require 'rubygems' 
require 'youtube_it'
require 'pony'
require 'nokogiri'

class SeeMe_Weekly

	def imdb(username, password, email)
		url = "http://www.imdb.com/boxoffice/"
		doc = Nokogiri::HTML(open(url))

		date = Array.new
		info = Array.new
		mod = Array.new

		title = doc.css('tbody tr:first-child a').text
		youtube(username, password, email, title)
	end

	def youtube(username, password, email, title)
		client = YouTubeIt::Client.new(:dev_key => "AI39si5vsKijaMlyBei8kMbMSiWPKu7e_RQITW1-jAINNI81R6nQWnBghSmyRXWNs5RtQUIXdOb4N8gQib-vfOT0axD59Nu8fQ")

		movie_trailer = client.videos_by(:query => title,:max_results => 1)
		box_office = movie_trailer.videos

		box_office.each do |link|
			@url = link.player_url
		end
		mail(@url, username, password, email)
	end

	def mail(url, username, password, email)
		Pony.mail({
  			:to => email,
  			:subject => "SeeMe Weekly",
  			:body => "Check out the number one movie at the box office this week! XOXO, Julia #{url}", 
  			:via => :smtp,
  			:via_options => {
    		:address              => 'smtp.gmail.com',
   			:port                 => '587',
    		:enable_starttls_auto => true,
   			:user_name            => username, 
   			:password             => password,
   			:authentication       => :plain, 
    		:domain               => "localhost.localdomain" 
  		}
		})

	end
end


get "/" do
	erb :index
end

get "/answer" do
	@username = params[:username]
	@password = params[:password]
	@email = params[:email]

	mywebapp = SeeMe_Weekly.new
	mywebapp.imdb(@username, @password, @email)
end


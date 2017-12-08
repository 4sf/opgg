require 'sinatra'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'csv'
require 'date'

get '/' do
	erb :index
end

get '/search' do
	@id = params["id"]

	@encoded = URI.encode(@id)
	response = HTTParty.get("http://www.op.gg/summoner/userName=" + @encoded)

  html = Nokogiri::HTML(response.body)
  @win = html.css('#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins')
  @loss = html.css('#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses')
  @tier = html.css('#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierRank > span')
	
	File.open("log.txt", "a+") do |f|     
	  f.write("#{@id}, #{@tier.text}, #{@win.text}, #{@loss.text}" + "\n")
	  # 아이디, 승, 패, 티어   
	end

	CSV.open("log.csv", "a+") do |csv|
		csv << [@id, @tier.text, @win.text, @loss.text]
	end

	erb :search
end
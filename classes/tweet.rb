class Tweet
  attr_accessor :content, :location, :created_at, :zombie, :unique_id

  @@tweet_id = 0
  @@all_tweets = []
  
  def initialize
    @unique_id = @@tweet_id
    @@all_tweets << self
    @@tweet_id += 1
  end
end

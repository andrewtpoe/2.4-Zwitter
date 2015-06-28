class Tweet
  attr_accessor :content, :location, :created_at,
                        :zombie, :unique_id, :favs, :retweets,
                        :original_tweet, :retweeted

  # Class level attributes
  @@tweet_id = 1
  @@all_tweets = []

  # Run this block on startup
  def initialize
    # Assign a unique id to each tweet and increment the counter
    @unique_id = @@tweet_id
    @@tweet_id += 1
    # Create an empty array to track this tweets favs
    @favs = []
    # We do track who retweets this tweet, we just count them
    @retweets = 0
    # If this tweet is a retweet, the original tweet is stored here.
    # Otherwise, this is left as false
    @original_tweet = false
    # Add this instance to the Class level array of tweets.
    @@all_tweets << self
  end

  # Searches for a tweet instance at the Class level based on the Unique ID
  # Returns either nil or the correct tweet.
  def self.find_tweet(unique_id)
    matching_tweet = nil
    @@all_tweets.each do | tweet |
      if tweet.unique_id == unique_id
        matching_tweet = tweet
      end
    end
    matching_tweet
  end

  # Creates an instance of the Fav class and stores it in the array.
  # Each instance of the Fav class is used to hold the zombie that
  # created it.
  def add_to_favs(zombie)
    f = Favs.new
    f.zombie = zombie
    @favs.push(f)
  end

end

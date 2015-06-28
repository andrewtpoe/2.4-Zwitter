class Zombie
  attr_accessor :name, :username, :password, :image,
                        :location, :bio, :created_at, :tweets, :stalkers,
                        :prey, :retweet # :logged_in

  # Class level array of Zombies, used for storing & searching in a few places
  @@instances = []

  # Run at startup
  def initialize
#    self.logged_in = false
    @tweets = []
    @stalkers = []
    @prey = []
    @image = "http://vignette3.wikia.nocookie.net/lego/images/8/81/Zombie_Groom.png/revision/latest?cb=20120823164249"
    @@instances << self
  end

  # Getter for the Class attribute instances
  def self.instances()
    @@instances
  end

  # Create class method that accepts username argument.
  # Returns instance of class with correct username.
  def self.find_zombie(username)
    matching_zombie = nil
    @@instances.each do | zombie |
      if zombie.username == username
        matching_zombie = zombie
      end
    end
    matching_zombie
  end

  # Create a new instance of the Tweet class with some content,
  # and store it in the array of this user's tweets
  def create_tweet(content:, location: nil)
    t = Tweet.new
    t.zombie = self
    t.content = content
    t.location = location
    @tweets.push(t)
    t
  end

  # Create and store a new tweet using an existing tweet's content
  def retweet(tweet_id)
    tweet = Tweet.find_tweet(tweet_id)
    t = create_tweet(content: tweet.content)
    t.retweeted = true
    t.original_tweet = tweet
    tweet.retweets += 1
    t
  end

  # Search through this user's tweets by tweet id and return the matching tweet.
  # Return nil if no match is found.
  def return_tweet(tweet_id)
    return_tweet = nil
    @tweets.each { | tweet | return_tweet = tweet if tweet.unique_id == tweet_id }
    return_tweet
  end

  # Verify that the user has a tweet, and delete it if the do.
  # Also, reduce the retweet counter of the original tweet if it was a retweet
  def delete_tweet(tweet_id)
    tweet = return_tweet(tweet_id)
    if tweet
      if tweet.original_tweet
        tweet.original_tweet.retweets -= 1
      end
    end
    @tweets.delete_if { | tweet | tweet.unique_id == tweet_id }
  end

  # Add a new zombie to this zombies prey list.
  def add_prey(username)
    zombie = Zombie.find_zombie(username)
    if zombie
      @prey.push(zombie)
      zombie.stalkers.push(self)
    end
  end

  # Delete the username passed in from the prey list,
  # and remove this zombie from that prey's stalker list.
  def delete_prey(username)
    @prey.delete_if do | victim |
      if victim.username == username
        victim.stalkers.delete_if { | lurker | lurker.username == @username }
      end
    end
  end

  # Add this zombie to a tweets favs array
  def add_fav(tweet_id)
    tweet = Tweet.find_tweet(tweet_id)
    tweet.add_to_favs(self)
  end

  # Remove this zombie from a tweets favs array.
  def delete_fav(tweet_id)
    tweet = Tweet.find_tweet(tweet_id)
    tweet.favs.delete_if do | fav |
      fav.zombie.username == @username
    end
  end

# Close the class
end

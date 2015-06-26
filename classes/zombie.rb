class Zombie
  attr_accessor :name, :username, :password, :image, :location, :bio, :created_at, :tweets, :stalkers, :prey

  @@instances = []

  def initialize
    self.tweets = []
    self.stalkers = []
    self.prey = []
    self.image = "http://vignette3.wikia.nocookie.net/lego/images/8/81/Zombie_Groom.png/revision/latest?cb=20120823164249"
    @@instances << self
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

  def create_tweet(content:, location: nil)
    t = Tweet.new
    t.zombie = self
    t.content = content
    t.location = location
    self.tweets.push(t)
    t
  end

  def delete_tweet(tweet_id)
    self.tweets.delete_if { | tweet | tweet.unique_id == tweet_id }
  end

  def add_prey(username)
    zombie = Zombie.find_zombie(username)
    if zombie
      self.prey.push(zombie)
      zombie.stalkers.push(self)
    end
  end

  # Should delete the username passed in from the prey list,
  # and remove this instance from that prey's stalker list.
  def delete_prey(username)
    self.prey.delete_if do | victim |
      if victim.username == username
        victim.stalkers.delete_if { | lurker | lurker.username == @username }
      end
    end
  end

  def add_fav(tweet_id)
    tweet = Tweet.find_tweet(tweet_id)
    tweet.add_to_favs(self)
  end

  def delete_fav(tweet_id)
    tweet = Tweet.find_tweet(tweet_id)
    tweet.favs.delete_if do | fav |
      fav.zombie.username == @username
    end
  end


end

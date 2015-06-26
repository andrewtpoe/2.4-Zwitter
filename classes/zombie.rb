class Zombie
  attr_accessor :name, :username, :password, :image, :location, :bio, :created_at, :tweets, :stalkers, :prey

  @@instances = []

  def initialize
    self.tweets = []
    self.stalkers = []
    self.prey = []
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
    self.prey.push(zombie)
    zombie.stalkers.push(self)
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

end

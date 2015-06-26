class Zombie
  attr_accessor :name, :username, :password, :image, :location, :bio, :created_at, :tweets, :next_tweet_id, :stalkers, :prey

  def initialize
    self.next_tweet_id = 0
    self.tweets = []
    self.stalkers = []
    self.prey = []
  end

  def create_tweet(content:, location: nil)
    t = Tweet.new
    t.zombie = self
    t.content = content
    t.location = location
    t.tweet_id = self.next_tweet_id
    self.next_tweet_id += 1
    self.tweets.push(t)
    t
  end

  def delete_tweet(tweet_id)
    self.tweets.delete_if { | tweet | tweet.tweet_id == tweet_id }
  end

  def add_prey(zombie)
    self.prey.push(zombie)
    zombie.stalkers.push(self)
  end

  def delete_prey(username)
    self.prey.delete_if do | victim |
      if victim.username == username
        victim.stalkers.delete_if { | lurker | lurker.username == @username }
      end
    end

  end
end

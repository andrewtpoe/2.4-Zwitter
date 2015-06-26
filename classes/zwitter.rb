class Zwitter
  attr_accessor :meesh, :poe, :ken

  def initialize
    @meesh = Zombie.new
    @meesh.username = "meesh"
    @meesh.password = "tibby"

    @poe = Zombie.new
    @poe.username = "poe"
    @poe.password = "secret"

    @ken = Zombie.new
    @ken.username = "ken"
    @ken.password = "grains"
  end

  def display_tweets(username)
    zombie = Zombie.find_zombie(username)
    if zombie
      tweets = zombie.tweets
      tweets.reverse_each do | tweet |
        puts "Content: #{tweet.content}"
        puts "Tweet Id: #{tweet.unique_id}"
        puts ""
      end
    end
  end

  def display_tweet_feed(username)
    zombie = Zombie.find_zombie(username)
    if zombie
      tweet_feed = []
      user_tweets = zombie.tweets
      tweet_feed.push(user_tweets)
      zombie.prey.each do | target |
        tweet_feed.push(target.tweets)
      end
      tweet_feed.flatten!
      tweet_feed.sort_by! { | tweet | tweet.unique_id }
      puts "YOUR ZWITTER FEED:"
      tweet_feed.reverse_each do | tweet |
        puts "Content: #{tweet.content}"
        print "Author: #{tweet.zombie.username} "
        print "Tweet Id: #{tweet.unique_id}"
        puts ""
      end
    end
  end

  def display_prey(username)
    zombie = Zombie.find_zombie(username)
    if zombie
      prey = zombie.prey
      prey.each do | victim |
        puts "Victim Name: #{victim.username}"
      end
      puts ""
    end
  end

  def show_stalkers(username)
    zombie = Zombie.find_zombie(username)
    if zombie
      stalkers = zombie.stalkers
      stalkers.each do | lurker |
        puts "Lurker Name: #{lurker.username}"
      end
      puts""
    end
  end

end

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

  def show_my_tweets(zombie)
    tweets = zombie.tweets
    tweets.reverse_each do | tweet |
      puts "Content: #{tweet.content}"
      puts "Tweet Id: #{tweet.tweet_id}"
      puts ""
    end
  end

  def display_my_prey(zombie)
    prey = zombie.prey
    prey.each do | victim |
      puts "Victim Name: #{victim.username}"
    end
    puts ""
  end

  def show_stalkers(zombie)
    stalkers = zombie.stalkers
    stalkers.each do | lurker |
      puts "Lurker Name: #{lurker.username}"
    end
    puts""
  end

end

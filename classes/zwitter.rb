class Zwitter
  attr_accessor :meesh, :poe, :ken

  USER_MENU = ['1: Create Tweet', '2: View Tweet Feed', '3: View My Tweets', '4: Browse Zombies', '5: View My Profile', '6: Logout']
  INTERACT_MENU = ['1: Create Tweet', '2: Retweet', '3: Delete Tweet', '4: Fave Tweet', '5: Unfave Tweet', '6: User Menu' ]
  LURKER_MENU = ['1: View All Zombies', '2: View My Prey', '3: Follow New Prey', '4: Unfollow Prey', '5: View My Stalkers', '6: User Menu' ]
  PROFILE_MENU = ['1: Edit Username', '2: Edit Password', '3: Edit Image', '4: Edit Location', '5: Edit Bio', '6: User Menu']

  def initialize
    @meesh = Zombie.new
    @meesh.username = "meesh"
    @meesh.password = "tibby"

    @poe = Zombie.new
    @poe.username = "poe"
    @poe.password = "secret"
    @poe.logged_in = true

    @ken = Zombie.new
    @ken.username = "ken"
    @ken.password = "grains"

    @ken.add_prey("poe")
    @poe.add_prey("meesh")

    @meesh.create_tweet(content: "gwains not bwains")
    @poe.create_tweet(content: "I want breakfast")
    @ken.create_tweet(content: "My car got booted")
    @poe.create_tweet(content: "wife is having coffee with a girlfriend")
    @meesh.create_tweet(content: "Tibby is my fav")
    @ken.create_tweet(content: "Yeah, i'm Italian.")
    @meesh.create_tweet(content: "word")

  end

  def user_menu(zombie)
    while zombie.logged_in
      puts "LOGGED IN: #{zombie.username}"
      puts "USER MENU:"
      puts ""
      # Get the user's menu selection
      user_men_sel = get_menu_selection(USER_MENU)
      case user_men_sel
      # 1: Create Tweet
      when 1
      content = get_input("What's on your mind?")
      tweet = zombie.create_tweet(content: content)
      display_tweet_feed(zombie)
      interact_menu(zombie)
      # 2: View Tweet Feed
      when 2
        display_tweet_feed(zombie)
        interact_menu(zombie)
      # 3: View My Tweets
      when 3
        display_tweets(zombie)
        interact_menu(zombie)
      # 4: Browse Zombies
      when 4
        view_all_other_zombies(zombie)
        lurker_menu(zombie)
      # 5: View/Edit/Delete My Profile
      when 5
        display_profile(zombie)
        profile_menu(zombie)
      # 6: Logout
      else
        zombie.logged_in = false
      end
    end
  end

  def interact_menu(zombie)
    interact_men_sel = true
    while interact_men_sel
      puts "INTERACTION MENU:"
      puts ""
      interact_men_sel = get_menu_selection(INTERACT_MENU)
      case interact_men_sel
      # 1: Create Tweet
      when 1
        content = get_input("What's on your mind?")
        tweet = zombie.create_tweet(content: content)
        display_tweet_feed(zombie)
      # 2: Retweet
      when 2
      # 3: Delete Tweet
      when 3
        display_tweets(zombie)
        print "TWEET ID TO DELETE: "
        tweet_id = gets.chomp.to_i
        puts ""
        tweet_to_delete = zombie.return_tweet(tweet_id)
        if tweet_to_delete
            puts "YOU SELECTED THIS TWEET:"
            puts ""
            show_single_tweet(zombie, tweet_to_delete)
          confirm = get_input("CONFIRM DELETE, TYPE Y OR N").downcase
          if confirm == "y"
            zombie.delete_tweet(tweet_id)
            puts "TWEET DELETED"
            puts ""
            display_tweet_feed(zombie)
          else
            puts "DELETE CANCELLED"
            puts ""
            display_tweet_feed(zombie)
          end
        else
          puts "YOU DO NOT HAVE A TWEET WITH THIS ID"
          puts ""
        end
      # 4: Fave Tweet
      when 4
        display_tweet_feed(zombie)
        print "TWEET ID TO FAV: "
        tweet_id = gets.chomp.to_i
        puts ""
        tweet = Tweet.find_tweet(tweet_id)
        if tweet
          already_favd = false
          tweet.favs.each do | fav |
            if fav.zombie.username == zombie.username
              already_favd = true
            end
          end
          if !already_favd
            tweet.add_to_favs(zombie)
            display_tweet_feed(zombie)
          else
            puts "YOU ALREADY FAV'D THIS TWEET."
            puts ""
          end
        else
          puts "TWEET ID DOES NOT EXIST"
          puts ""
          display_tweet_feed(zombie)
        end
      # 5: Unfave Tweet
      when 5
        display_tweet_feed(zombie)
        print "TWEET ID TO UNFAV: "
        tweet_id = gets.chomp.to_i
        puts ""
        tweet = Tweet.find_tweet(tweet_id)
        if tweet
          zombie.delete_fav(tweet_id)
          display_tweet_feed(zombie)
        end
      # 6: User Menu
      else
        interact_men_sel = false
      end
    end
  end

  def view_all_other_zombies(zombie)
    Zombie.instances.each_with_index do | zom, index |
      unless zom.username == zombie.username
        puts "ZOMBIE #{index + 1}: #{zom.username}"
      end
    end
    puts ""
  end

  def lurker_menu(zombie)
    lurker_men_sel = true
    while lurker_men_sel
      puts "LURKER MENU:"
      puts ""
      lurker_men_sel = get_menu_selection(LURKER_MENU)
      case lurker_men_sel
      # 1: View All Other Zombies
      when 1
        view_all_other_zombies(zombie)
      # 2: View My Prey
      when 2
        display_prey(zombie)
      # 3: Follow New Prey
      when 3
        view_all_other_zombies(zombie)
        print "ZOMBIE USERNAME TO STALK: "
        username = gets.chomp
        puts ""
        new_prey = Zombie.find_zombie(username)
        if new_prey
          already_stalking = false
          zombie.prey.each do | pot_prey |
            if pot_prey.username == username
              already_stalking = true
            end
          end
          if ! already_stalking
            zombie.add_prey(username)
            puts "NOW STALKING: #{username}"
            puts ""
          else
            puts "ALREADY STALKING THIS ZOMBIE"
            puts ""
          end
        else
          puts "NO ZOMBIE FOUND BY THAT USERNAME"
          puts ""
        end
      # 4: Unfollow Prey
      when 4
        display_prey(zombie)
        print "ZOMBIE USERNAME TO STOP STALKING: "
        username = gets.chomp
        puts ""
        match_found = false
        zombie.prey.each do | target |
          if username == target.username
            match_found = true
          end
        end
        if match_found
          zombie.delete_prey(username)
          puts "STOPPED STALKING: #{username}"
          puts ""
        else
          puts "YOU HAVE NO PREY BY THAT USERNAME"
          puts ""
        end
      # 5: View My Stalkers
      when 5
        show_stalkers(zombie)
      # 6: User Menu
      else
        lurker_men_sel = false
      end
    end
  end

    def display_profile(zombie)
      puts "ZOMBIE PROFILE FOR: #{zombie.username}"
      puts ""
      puts "USERNAME: #{zombie.username}"
      puts "PASSWORD: #{zombie.password}"
      puts "IMAGE: #{zombie.image}"
      puts "LOCATION: #{zombie.location}"
      puts "BIO: #{zombie.bio}"
      puts "STALKING:"
      zombie.prey.each { | target | puts " #{target.username}" }
      puts "STALKED BY:"
      zombie.stalkers.each { | lurker | puts "  #{lurker.username}"}
      puts ""
    end

    def profile_menu(zombie)
      profile_men_sel = true
      while profile_men_sel
        puts "PROFILE MENU:"
        puts ""
        profile_men_sel = get_menu_selection(PROFILE_MENU)
        case profile_men_sel
        # 1: Edit Username
        when 1
          print "ENTER YOUR NEW USERNAME: "
          new_name = gets.chomp
          puts ""
          zombie.username = new_name
          puts "UPDATED USERNAME"
          puts ""
          display_profile(zombie)
        # 2: Edit Password
        when 2
          print "ENTER YOUR NEW PASSWORD: "
          new_pass = gets.chomp
          puts ""
          zombie.password = new_pass
          puts "UPDATED PASSWORD"
          puts ""
          display_profile(zombie)
        # 3: Edit Image
        when 3
          print "ENTER YOUR NEW IMAGE URL: "
          new_img = gets.chomp
          puts ""
          zombie.image = new_img
          puts "UPDATED IMAGE"
          puts ""
          display_profile(zombie)
        # 4: Edit Location
        when 4
          print "ENTER YOUR NEW LOCATION: "
          new_loc = gets.chomp
          puts ""
          zombie.loc = new_loc
          puts "UPDATED LOCATION"
          puts ""
          display_profile(zombie)
        # 5: Edit Bio
        when 5
          print "ENTER YOUR NEW BIO: "
          new_bio = gets.chomp
          puts ""
          zombie.bio = new_bio
          puts "UPDATED USERNAME"
          puts ""
          display_profile(zombie)
        # 6: User Menu
        else
          profile_men_sel = false
        end
      end
    end

  # This method displays a menu and verifies that the
  # input collected and returned is a valid option.
  # Menu must be an array with options starting at 1.
  def get_menu_selection(menu)
    men_sel = 0
    until (1..menu.count).include?(men_sel)
      men_sel = get_input(menu.join("\n")).to_i
      unless (1..menu.count).include?(men_sel)
        puts "Invalid entry. Try again."
        puts ""
      end
    end
    men_sel
  end

  # This method displays input prompt and returns the value input as a string.
  # Loops until input is given.
  def get_input(prompt)
    var = ""
    while var == ""
      puts "#{prompt}"
      print ">> "
      var = gets.chomp
      puts ""
    end
    var
  end

  def display_tweets(zombie)
    # Changed this block of code. Now passing in a specific zombie instead of username
    # therefore we don't need to find the zombie
    # zombie = Zombie.find_zombie(username)
    if zombie
      tweets = zombie.tweets
      puts "YOUR TWEETS:"
      puts ""
#      tweets.reverse_each do | tweet |
      tweets.each do | tweet |
        show_single_tweet(zombie, tweet)
      end
    end
  end

  def display_tweet_feed(zombie)
    # Changed this block of code. Now passing in a specific zombie instead of username
    # therefore we don't need to find the zombie
    # zombie = Zombie.find_zombie(username)
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
      puts ""
#      tweet_feed.reverse_each do | tweet |
      tweet_feed.each do | tweet |
        show_single_tweet(zombie, tweet)
      end
    end
  end

  def show_single_tweet(zombie, tweet)
    puts "Content: #{tweet.content} "
    print "Author: #{tweet.zombie.username} | "
    print "Tweet Id: #{tweet.unique_id} | "
    print "Favs: #{tweet.favs.length} "
    already_favd = false
    tweet.favs.each do | fav |
      if fav.zombie.username == zombie.username
        already_favd = true
      end
    end
    if already_favd
      print "<3"
    end
    puts "\n\n"
  end

  def display_prey(zombie)
    # Changed this block of code. Now passing in a specific zombie instead of username
    # therefore we don't need to find the zombie
    # zombie = Zombie.find_zombie(username)
    if zombie
      prey = zombie.prey
      puts "YOUR PREY:"
      puts ""
      prey.each do | target |
        puts "USERNAME: #{target.username}"
      end
      puts ""
    end
  end

  def show_stalkers(zombie)
    # Changed this block of code. Now passing in a specific zombie instead of username
    # therefore we don't need to find the zombie
    # zombie = Zombie.find_zombie(username)
    if zombie
      stalkers = zombie.stalkers
      puts "YOUR STALKERS:"
      puts ""
      stalkers.each do | lurker |
        puts "USERNAME: #{lurker.username}"
      end
      puts""
    end
  end

end

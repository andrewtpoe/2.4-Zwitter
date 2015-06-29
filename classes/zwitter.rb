class Zwitter
  attr_accessor :meesh, :poe, :ken, :show_user_menu

  MAIN_MENU = ['1: Login', '2: Sign up for Zwitter', '3: Exit']
  USER_MENU = ['1: Create Tweet', '2: View Tweet Feed', '3: View My Tweets', '4: Browse Zombies', '5: View My Profile', '6: Logout']
  INTERACT_MENU = ['1: Create Tweet', '2: Retweet', '3: Delete Tweet', '4: Fave Tweet', '5: Unfave Tweet', '6: User Menu' ]
  LURKER_MENU = ['1: View All Zombies', '2: View My Prey', '3: Follow New Prey', '4: Unfollow Prey', '5: View My Stalkers', '6: User Menu' ]
  PROFILE_MENU = ['1: Edit Username', '2: Edit Password', '3: Edit Image', '4: Edit Location', '5: Edit Bio', '6: User Menu']

  # Run at startup
  def initialize
    # Create some default zombies...
    @meesh = Zombie.new
    @meesh.username = "meesh"
    @meesh.password = "tibby"

    @poe = Zombie.new
    @poe.username = "poe"
    @poe.password = "secret"

    @ken = Zombie.new
    @ken.username = "ken"
    @ken.password = "grains"

    @ken.add_prey("poe")
    @poe.add_prey("meesh")

    # Populate Zwitter with some default tweets
    @meesh.create_tweet(content: "gwains not bwains")
    @poe.create_tweet(content: "I want breakfast")
    @ken.create_tweet(content: "My car got booted")
    @poe.create_tweet(content: "wife is having coffee with a girlfriend")
    @meesh.create_tweet(content: "Tibby is my fav")
    @ken.create_tweet(content: "Yeah, i'm Italian.")
    @meesh.create_tweet(content: "word")
    @poe.create_tweet(content: "Coding turned me into a zombie.")
    @meesh.create_tweet(content: "That's what she said")
    @ken.create_tweet(content: "testing time... yay...")
    @ken.create_tweet(content: "Favorit flavor: couch potato")

    # Display the main menu
    show_main_menu
  end

  # Displays and operates the main menu
  def show_main_menu
    main_menu_sel = true
    error = {}
    while main_menu_sel
      puts "Welcome to Zwitter! "
      puts "Login to learn the latest on all things bwaaains!"
      puts ""
      main_menu_sel = get_menu_selection(MAIN_MENU)
      case main_menu_sel
      # zombie login
      when 1
        @show_user_menu = false
        zombie = nil
        login = get_zombie_login()
        zombie = get_zombie(login)
        while @show_user_menu
          user_menu(zombie)
          @show_user_menu = false
        end
        # Join Zwitter
        when 2
          puts "Join Zwitter today"
          puts ""
          zombie = Zombie.new
          # Create username
          zombie_exists = nil
          unless zombie_exists
            zombie_name = get_input("CREATE USERNAME")
            # print "CREATE USERNAME: "
            # zombie_name = gets.chomp
            zombie_exists = Zombie.find_zombie(zombie_name)
            if zombie_exists
              puts "This Zombie is already Roaming"
              puts ""
            else
              zombie.username = zombie_name
              pass = get_input("CREATE PASSWORD")
              # print "CREATE PASSWORD: "
              # pass = gets.chomp
              zombie.password = pass
              @show_user_menu = true
              while @show_user_menu
                user_menu(zombie)
                @show_user_menu = false
              end
            end
          end
      when 3
        puts "Happy hunting! Goodbye."
        puts ''
        main_menu_sel = false
      else
        display_error()
        main_menu_sel = false
        error[:error] = "The world is ending. Drop this device and enjoy your last brain!"
      end
    end
  end

  # Displays and operates the user menu
  def user_menu(zombie)
    display_tweet_feed(zombie)
    user_men_sel = true
    while user_men_sel
      puts "LOGGED IN: #{zombie.username}"
      puts "USER MENU:"
      puts ""
      # Get the user's menu selection
      user_men_sel = get_menu_selection(USER_MENU)
      case user_men_sel
      # 1: Create Tweet
      when 1
      content = get_input("What's on your mind (besides brains)?")
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
        puts "LOGGING OUT"
        puts ""
        user_men_sel = false
#        show_main_menu()
      end
    end
  end

  # Displays and operates the interaction menu
  def interact_menu(zombie)
    interact_men_sel = true
    while interact_men_sel
      puts "INTERACTION MENU:"
      puts ""
      interact_men_sel = get_menu_selection(INTERACT_MENU)
      case interact_men_sel
      # 1: Create Tweet
      when 1
        content = get_input("What's on your mind (besides brains)?")
        tweet = zombie.create_tweet(content: content)
        display_tweet_feed(zombie)
      # 2: Retweet
      when 2
        display_tweet_feed(zombie)
        print "TWEET ID TO RETWEET: "
        tweet_id = gets.chomp.to_i
        puts ""
        tweet_to_retweet = Tweet.find_tweet(tweet_id)
        if tweet_to_retweet
          retweet = zombie.retweet(tweet_id)
          puts "RETWEETED:"
          puts ""
          show_single_tweet(zombie, retweet)
        else
          puts "NO TWEET EXISTS WITH THIS ID"
          puts ""
        end
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

  # Displays and operates the lurker menu
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

  # Displays and operates the profile menu
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
        zombie.location = new_loc
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

  # Displays all zombies except the zombie currently logged in
  def view_all_other_zombies(zombie)
    Zombie.instances.each_with_index do | zom, index |
      unless zom.username == zombie.username
        puts "ZOMBIE #{index + 1}: #{zom.username}"
      end
    end
    puts ""
  end

  # Displays this zombie's user profile
  def display_profile(zombie)
    puts "ZOMBIE PROFILE FOR: #{zombie.username}"
    puts ""
    puts "USERNAME: #{zombie.username}"
    puts "PASSWORD: #{zombie.password}"
    puts "IMAGE: #{zombie.image}"
    puts "LOCATION: #{zombie.location}"
    puts "BIO: #{zombie.bio}"
    puts "STALKING:"
    zombie.prey.each { | target | puts "  #{target.username}" }
    puts "STALKED BY:"
    zombie.stalkers.each { | lurker | puts "  #{lurker.username}"}
    puts ""
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

  # Asks for login information, returns a hash
  def get_zombie_login
    username = get_input('Please enter your username')
    password = get_input('Please enter your password')
    login = { username: username, password: password }
    login
  end

  # Finds zombie based on login hash, returns verified zombie
  def get_zombie(login)
    matching_zombie = false
    Zombie.instances.each do | zombie |
      if zombie.username == login[:username] && zombie.password == login[:password]
        @show_user_menu = true
        matching_zombie = zombie
        puts "Your account has been verified."
        puts ''
      end
    end
    unless matching_zombie
      puts "Start over."
      puts ''
    end
    matching_zombie
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

  # Displays this zombies tweets
  def display_tweets(zombie)
    if zombie
      tweets = zombie.tweets
      puts "YOUR TWEETS:"
      puts ""
      tweets.each do | tweet |
        show_single_tweet(zombie, tweet)
      end
    end
  end

  # Displays the tweet feed for this zombie
  def display_tweet_feed(zombie)
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
      tweet_feed.each do | tweet |
        show_single_tweet(zombie, tweet)
      end
    end
  end

  # Outputs to the screen the content and useful information about a single tweet
  def show_single_tweet(zombie, tweet)
    puts "Content: #{tweet.content} "
    print "Author: #{tweet.zombie.username} | "
    print "Tweet Id: #{tweet.unique_id} | "
    print "Retweets: #{tweet.retweets} | "
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

  # Displays the prey for this zombie
  def display_prey(zombie)
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

  # Displays the stalkers for this zombie.
  def show_stalkers(zombie)
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

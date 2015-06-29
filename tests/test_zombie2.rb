require 'minitest/autorun'
require_relative '../classes/zombie.rb'
#require_relative '../app.rb'

class TestZombie < MiniTest::Test
  def setup
    @a_zombie = Zombie.new
    @a_zombie.username = "a_zombie"
    @prey = Zombie.new
    @prey.username = "PREY"
    @stalker = Zombie.new
    @stalker.username = "STALKER"
    @a_user.a_zombie = Zombie.new(username: "a_zombie", password: "a_password")
    @a_tweet = @a_zombie.create_tweet(content: "favor flav - couch potato", location: nil)
    @content = "Something brainy"
  end

  def test_class_method_find_user_by_username_returns_correct_user
    found_zombie = Zombie.find_zombie("a_zombie")
    assert_equal "a_zombie", found_zombie.username
  end

  def test_class_method_find_user_by_username_returns_nil_if_no_match_found
    found_zombie = Zombie.find_zombie("BwainEater")
    assert_equal nil, found_zombie
  end

  def test_self_deleted_from_lurker_list
    @stalker.prey.push(@prey)
    @prey.stalkers.push(@stalker)
    @stalker.delete_prey("PREY")
    has_stalker = false
    @prey.stalkers.each do | stalker |
      if stalker.username == "STALKER"
        has_stalker = true
      end
    end
    assert_equal false, has_stalker
  end

  def test_create_tweet
    assert_equal "a_zombie", @a_tweet.username
    assert_equal "Something brainy", @a_tweet.content
    assert_equal nil, @a_tweet.location
  end

  def test_delete_tweet
    @a_tweet.delete
    assert_equal nil, @a_tweet.location
    assert_equal nil, @a_tweet.content
    assert_equal [], @a_retweet
  end

  def test_retweet
    @a_re_zom = Zombie.new(username: "a_zombie", password: "a_password")
    @a_retweet = @a_tweet.retweet(a_re_zom: @a_re_zom)
    assert_equal "a_zombie", @a_retweet.user.username
    assert_equal nil, @a_retweet, @a_retweet.location
    out, _ = capture_io do
      @re_tweet.view
    end
    assert_includes @a_re_zom.tweets, @re_tweet
    assert_includes @tweet.re_tweet, @re_tweet
    assert_includes @tweet.re_tweet_by, @a_re_zom
  end

end

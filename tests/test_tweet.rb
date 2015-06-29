require 'minitest/autorun'
require_relative '../classes/tweet.rb'
#require_relative '../app.rb'

class TestTweet < MiniTest::Test

  def setup
    @a_tweet = Tweet.new
    @a_tweet.unique_id = "a_tweet"
    @a_fav = Favs.new
    @a_fav.zombie = "FAVORITE"
  end

  def test_find_tweet_by_unique_id
    fount_tweet = Tweet.find_tweet("a_tweet")
    assert_equal "a_tweet", found_tweet.unique_id
  end

  def test_find_tweet_by_unique_id_returns_nil_if_no_match_found
    found_tweet = Tweet.find_tweet("2")
    assert_equal nil, found_tweet
  end

  def test_add_to_favs
    added_fav = Favs.added_favs("a_fav")
    assert_equal "a_fav", added_fav.zombie
  end

  def test_add_to_favs_returns_nil_if_no_match_found
    added_fav = Favs.added_favs("WHERE DA BWAINS AT?")
    assert_equal nil, added_fav
  end
end

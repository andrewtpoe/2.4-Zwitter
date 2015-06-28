require 'minitest/autorun'
require_relative '../classes/zombie.rb'

class TestZombie < MiniTest::Test
  def setup
    @a_zombie = Zombie.new
    @a_zombie.username = "a_zombie"
    @prey = Zombie.new
    @prey.username = "***PREY***"
    @stalker = Zombie.new
    @stalker.username = "***STALKER***"
  end

  def test_class_method_find_user_by_username_returns_correct_user
    found_zombie = Zombie.find_zombie("a_zombie")
    assert_equal "a_zombie", found_zombie.username
  end

  def test_class_method_find_user_by_username_returns_nil_if_no_match_found
    found_zombie = Zombie.find_zombie("BwainEater")
    assert_equal nil, found_zombie
  end

  def test_self_deleted_from_preys_stalker_list
    @stalker.prey.push(@prey)
    @prey.stalkers.push(@stalker)
    @stalker.delete_prey("***PREY***")
    has_stalker = false
    @prey.stalkers.each do | stalker |
      if stalker.username == "***STALKER***"
#        puts "THIS STALKER EXISTS"
        has_stalker = true
      end
    end
    # puts "Prey's stalkers: #{prey.stalkers.inspect}"
    # puts ""
    # puts "Stalker's prey: #{stalker.prey.inspect}"
    assert_equal false, has_stalker
  end
end

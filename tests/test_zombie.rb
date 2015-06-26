require 'minitest/autorun'
require_relative '../app.rb'

class TestZombie < MiniTest::Test
  def setup
  end

  def test_self_deleted_from_preys_stalker_list
    prey = Zombie.new
    prey.username = "***PREY***"
    stalker = Zombie.new
    stalker.username = "***STALKER***"
    stalker.prey.push(prey)
    prey.stalkers.push(stalker)
    stalker.delete_prey(prey)
    # Check to see if zombie1 has a stalker zombie2
    has_stalker = false
    prey.stalkers.each do | stalker |
      if stalker.username == "***STALKER***"
        puts "THIS STALKER EXISTS"
        has_stalker = true
      end
    end
    puts prey.stalkers.inspect
    puts stalker.prey.inspect

    assert_equal false, has_stalker
  end
end

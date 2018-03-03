require 'test_helper'

module SimplyAuth
  class UserTest < ActiveSupport::TestCase
    test "crud" do
      pool = UserPool.new(name: "test pool")
      assert_equal true, pool.save

      user = User.new(user_pool_id: pool.id)
      assert_equal false, user.save
      assert_equal ["Email is invalid", "Password is too short (minimum is 6 characters)"], user.errors.full_messages

      user.email = "a@bee.com"
      user.password = "f@ncyp@ss"
      assert_equal true, user.save
      assert_equal "a@bee.com", user.email
      assert_nil user.password # password has been encrypted irreversibly
      assert_not_nil user.id
      assert_equal [], user.errors.full_messages

      found = User.find([pool.id, user.id])
      assert_equal user.id, found.id
      assert_equal "a@bee.com", found.email
      assert_nil found.password # password has been encrypted irreversibly

      found.name = "bill"
      found.email = "c@bee.com"
      found.data.something = "a value" #store anything you want on data, as long as it's a string
      assert_equal true, found.save

      found = User.find([pool.id, user.id])
      assert_equal "bill", found.name
      assert_equal "c@bee.com", found.email
      assert_equal "a value", found.data.something

      users = User.all(pool.id)
      assert_equal(["c@bee.com"], users.map(&:email))

      users = pool.users
      assert_equal(["c@bee.com"], users.map(&:email))
    end
  end
end
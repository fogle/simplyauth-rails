require 'test_helper'

module SimplyAuth
  class SessionTest < ActiveSupport::TestCase
    test "crud" do
      pool = UserPool.new(name: "test pool")
      assert_equal true, pool.save

      password = "the password"
      user = User.new(user_pool_id: pool.id, email: "test@example.com", password: password)
      assert_equal true, user.save

      session = Session.new(user_pool_id: pool.id)
      assert_equal false, session.save
      assert_equal ["Email is invalid", "Password is too short (minimum is 6 characters)"], session.errors.full_messages

      session.email = user.email
      session.password = password
      assert_equal true, session.save
      assert_nil session.email
      assert_nil session.password # password has been encrypted irreversibly
      assert_equal user.id, session.user.id
      assert_equal user.email, session.user.email
      assert_nil session.user.password # password has been encrypted irreversibly
      assert_not_nil session.id
      assert_equal [], session.errors.full_messages

      found = Session.find([pool.id, session.id])
      assert_nil found.email
      assert_nil found.password # password has been encrypted irreversibly
      assert_equal user.id, found.user.id
      assert_equal user.email, found.user.email
      assert_nil found.user.password # password has been encrypted irreversibly

      session.destroy

      begin
        Session.find([pool.id, session.id])
        raise "should have failed"
      rescue RestClient::NotFound => e
        # correct to not be found
      end
    end
  end
end
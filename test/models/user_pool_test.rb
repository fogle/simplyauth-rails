require 'test_helper'

module SimplyAuth
  class UserPoolTest < ActiveSupport::TestCase
    test "crud" do
      preexisting_ids = UserPool.all.map(&:id)
      up = UserPool.new
      assert_equal false, up.save
      assert_equal ["Name can't be blank"], up.errors.full_messages

      up.name = "fred"
      assert_equal true, up.save
      assert_equal "fred", up.name
      assert_equal [], up.errors.full_messages
      assert_not_nil up.id

      found = UserPool.find(up.id)
      assert_equal "fred", found.name
      assert_equal up.id, found.id

      found.name = "bill"
      assert_equal(true, found.save)

      found = UserPool.find(up.id)
      assert_equal "bill", found.name

      new_pools = UserPool.all.reject{|up|preexisting_ids.include?(up.id)}
      assert_equal(["bill"], new_pools.map(&:name))
    end
  end
end
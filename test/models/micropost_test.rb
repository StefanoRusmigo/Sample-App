require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
	def setup
		@user = users(:michael)
		@micropost = @user.microposts.build(content:"Lorem Ipsum")
	end

	test "micropost should be valid" do 
		assert @micropost.valid?
	end

	test "not valid if user_id not present" do 
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end

	test "content->presence and length" do
		@micropost.content = "  "
		assert_not @micropost.valid?
		@micropost.content = "a" * 141
		assert_not @micropost.valid?
	end

	test "micropost to appear in reverse chronological order" do 
		assert_equal microposts(:most_recent), Micropost.first
	end
end

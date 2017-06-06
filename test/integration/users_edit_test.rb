require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
	end

	test "unsuccesful edit" do 
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path, params:{user:{name:"",email:"foo@invalid", password:"foo", password_confirmation:"bar"}}
		assert_template 'users/edit'
		assert_select('div.alert', {text:"The form contains 4 errors", count:1} )
	end

	test "succesful edit with friendly forwarding" do 
		get edit_user_path(@user)
		assert session[:forwarding_url]
 	 	assert_redirected_to login_path
  		log_in_as(@user)
  		assert_redirected_to edit_user_path(@user)
  		assert_not session[:forwarding_url]
  		follow_redirect!
		assert_template 'users/edit'
		patch user_path(@user), params:{user:{name:"Foo Bar",email:"foo@bar.com", password:"",password_confirmation:""}}
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal @user.name, "Foo Bar"
		assert_equal @user.email, "foo@bar.com"

	end

end

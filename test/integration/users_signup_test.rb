require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end


  test "Invalid signup information" do 
  	get signup_path
  	assert_no_difference 'User.count' do 
  		post users_path, params:{ user: { name: "", email: "user@invalid", password: "foo", password_confirmation:"bar"}}
  	end
  	assert_template "users/new"
  	assert_select "div.alert","The form contains 4 errors"
  	assert_select "li","Name can't be blank"
  end

  test "Valid signup" do
    assert_difference "User.count",1 do 
      post users_path,  params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end 
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
    assert_select "div.alert-success","Welcome to Sample App!!" #this test is likely to fail in the future.  Testing only if flash exists is enough
  end
end

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear #Because the deliveries array is global, we have to reset it in the setup method to prevent our code from breaking if any other tests deliver email 
  end

  test "Invalid signup information" do 
  	get signup_path
  	assert_no_difference 'User.count' do 
  		post users_path, params:{ user: { name: "", email: "user@invalid", password: "foo", password_confirmation:"bar"}}
  	end
  	assert_template "users/new"
  	assert_select "div.alert","The form contains 4 errors"
  	assert_select "li","Name can't be blank"
  end

  test "Valid signup with account activation" do
    get signup_path
    assert_difference "User.count",1 do 
      post users_path,  params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end 
    assert_equal 1,ActionMailer::Base.deliveries.size
    user = assigns(:user)#assigns lets us access instance variables in the corresponding action.
    assert_not user.activated?
    # try login before activation
    log_in_as(user)
    assert_not flash.empty?
    assert_not is_logged_in?
    #invalid activation token
    get edit_account_activation_path("invalid token",email: user.email)
    assert_not is_logged_in?
    assert_not flash.empty?
    #valid token, wrong email
    get edit_account_activation_path(user.activation_token,email:"wrong")
    assert_not is_logged_in?
    assert_not flash.empty?
    #valid activation
    get edit_account_activation_path(user.activation_token,email: user.email)
    assert is_logged_in?
    assert user.reload.activated?
    follow_redirect!
    assert 'users/show'
    assert_not flash.empty?
  end
end

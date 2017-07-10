require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:michael)
  	@user2 = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do 
  	get edit_user_path(@user)
  	assert_not flash.empty?
  	assert_redirected_to login_path	
  end


  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when trying to access other users page" do
  	log_in_as(@user)
  	get edit_user_path(@user2)
  	assert flash.empty?
  	assert_redirected_to root_url
  end 

    test "should redirect update when logged in as wrong user" do
    log_in_as(@user)
    patch user_path(@user2), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user2)
    assert_not @user2.admin?
    patch user_path(@user2), params: {
                                    user: { admin: true } }
    assert_not @user2.reload.admin?
  end

test "delete request when not logged-in should redirect to login page" do
  assert_no_difference 'User.count' do 
    delete user_path @user2
  end
  assert_redirected_to login_path
end

test "delete request when logged-in but not an admin should redirect to login page" do 
  log_in_as @user2
  assert_no_difference 'User.count' do 
    delete user_path(@user)
  end
  assert_redirected_to root_url
end

test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end


end

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
  	@user = User.new(name: "Example User", email: "user@example.com",password: "foobar",password_confirmation:"foobar")
  end

  test "should be valid" do 
  	assert @user.valid?
  end

  test "name should be present" do 
  	@user.name = "  "
  	assert_not @user.valid?
  end

   test "email should be present" do 
  	@user.email = "  "
  	assert_not @user.valid?
  end

  test "name not longer that 50 char" do 
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

   test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com  foo@bar..com ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "mixed case email" do 
    mixed_case = "Foo@ExAMPle.CoM"
    @user.email = mixed_case
    @user.save
    assert_equal mixed_case.downcase,@user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

    test "password should have a minimum length" do
      @user.password = @user.password_confirmation = 'a' * 5
      assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
      assert_not @user.authenticated?(:remember,'')
    end

    test "dependent: :destoy" do 
      @user.save
      @user.microposts.create!(content:"Apoel")
      assert_difference 'Micropost.count', -1 do
        @user.destroy
      end
    end

    test "follow another user" do 
      user = users(:michael) 
      other_user = users(:archer)
      assert_not user.following?(other_user)
      user.follow(other_user)
      assert user.following?(other_user)
      assert other_user.followers.include?(user)
      user.unfollow(other_user)
      assert_not user.following?(other_user)
      end

      test "feed has the right posts" do
       michael = users(:michael)
       archer  = users(:archer)
       lana    = users(:lana)
       #followed user
       lana.microposts.each do |post|
       assert michael.feed.include?(post)
       end     
       #not followed user
        archer.microposts.each do |post|
          assert_not michael.feed.include?(post)
       end    
       #posts from self  
        michael.microposts.each do |post|
          assert michael.feed.include?(post)
       end
      end


end

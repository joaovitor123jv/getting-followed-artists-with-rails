require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should not create user withouth uid' do
    user = User.new
    user.access_token = 'sajdlksjkadlsjkdl'
    assert_not user.save
  end

  test 'should not create user withouth access_token' do
    user = User.new
    user.uid = 'ljdskladjkasld'
    assert_not user.save
  end

  test 'should not create user with small access token' do
    user = User.new
    user.uid = '123456789'
    user.access_token = '123456789'
    assert_not user.save
  end

  test 'should not create user with duplicate uid' do
    user1 = User.new
    user1.uid = '15151515151'
    user1.access_token = '156156156156156'
    assert user1.save

    user2 = User.new
    user2.uid = user1.uid
    user2.access_token = '49874512asdhakj0'
    assert_not user2.save
  end

  test 'should not create user with duplicate access_token' do
    user1 = User.new
    user1.uid = '15151515151'
    user1.access_token = '156156156156156'
    assert user1.save

    user2 = User.new
    user2.uid = 'oaisudjiojidosa'
    user2.access_token = user1.access_token
    assert_not user2.save
  end

  test 'should save user with api_access_token' do
    user1 = User.new
    user1.uid = '15151515151'
    user1.access_token = '156156156156156'
    user1.api_access_token = 'djas90djsa90djsa'
    assert user1.save
  end
end

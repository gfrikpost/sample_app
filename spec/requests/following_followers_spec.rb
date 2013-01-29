require 'spec_helper'

describe "following_followers" do
  
  before(:each) do
    @user = Factory(:user)
    @other_user = Factory(:user, :email => Factory.next(:email))
    @micropost = Factory(:micropost, :user => @other_user)
    integration_sign_in(@user)
  end
  
  describe "should show followed micropost" do
    
    before(:each) do
      visit user_path(@other_user)
      click_button
    end
    
    it "should displayed a follower user microposts" do
      visit root_path
      response.should have_selector("span.content", :content => @micropost.content)
    end
  end
  
  describe "should not show unfollow users" do
    
    before(:each) do
      @user.follow!(@other_user)
      visit user_path(@other_user)
      click_button
    end
    
    it "should not displayed a unfollow user microposts" do
      visit root_path
      response.should_not have_selector("span.content", :content => @micropost.content)
    end
  end
end

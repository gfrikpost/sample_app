require 'spec_helper'

describe "LayoutLinks" do
  
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end
  
  it "should have a Home page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end
  
  it "should have a Home page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
   # click_link "Sign up now!"
   # response.should have_selector('title', :content => "Sign up now!")
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end
  
  describe "when signed in" do
    
    before(:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
    end
    
    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end
    
    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profile")
    end
  end
  
  describe "when admin user" do
    
    before(:each) do
      @admin = Factory(:user, :email => "admin@example.com", :admin => true)
      integration_sign_in(@admin)
    end
    
    it "should have a delete link" do
      visit users_path
      response.should have_selector("a", :href => user_path(@admin),
                                    :title => "Delete #{@admin.name}")
    end
  end
  
  describe "when a normal user" do
    
    before(:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
    end
    
    it "should not have a delete link" do
      visit user_path
      response.should_not have_selector("a", :href => user_path(@user),
                                        :title => "Delete #{@user.name}")
    end
  end
  
  describe "link 'delete' not visible for another user" do
    
    before(:each) do
      @user = Factory(:user)
      @second_user = Factory(:user, :name => "Bob", :email => "another@example.com")
      integration_sign_in(@user)
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
    end
    
    it "should not have a delete link" do
      integration_sign_in(@second_user)
      visit "/users/1"
      response.should_not have_selector("a", :href => "/microposts/1",
                                          :content => "delete",
                                          :title => "Foo bar")
    end
  end
  
end

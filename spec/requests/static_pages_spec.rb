require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_h1_text( heading ) }
    it { should have_title_text( full_title(page_title) ) }
  end

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        31.times { FactoryGirl.create(:micropost, user: user) }
        sign_in user
        visit root_path
      end

      after { user.microposts.delete_all }

      it "should render the user's feed" do
        user.feed[1..28].each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should have micropost count and pluralize" do
        page.should have_content('31 microposts')
      end

      it "should paginate after 31" do
        page.should have_selector('div.pagination')
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_title_text( full_title('About Us') )
    click_link "Help"
    page.should have_title_text( full_title('Help') )
    click_link "Contact"
    page.should have_title_text( full_title('Contact') )
    click_link "Home"
    click_link "Sign up now!"
    page.should have_title_text( full_title('Sign up') )
    click_link "sample app"
    page.should have_title_text( full_title('') )
  end

end
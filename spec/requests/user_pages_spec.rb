require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_h1_text('Sign up') }
    it { should have_title_text('Sign up') }
  end

  describe "profile page" do
    # user id numbers are so high on dev b/c .create saves - might want to switch to .build
    # @todo: breaks with use .build - look for work around
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_h1_text( user.name ) }
    it { should have_title_text( user.name ) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title_text('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      let(:user) {FactoryGirl.build(:user)} # FactoryGirl.create will save the instance, you should be using build instead
      before { valid_signup(user) }

      describe "after saving the user" do
        before { click_button submit }

        it { should have_title_text( user.name ) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_h1_text( 'All users' ) }
    it { should have_title_text( 'All users' ) }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_h1_text("Update your Profile") }
      it { should have_title_text("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title_text( new_name ) }
      it { should have_success_message('Profile updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "destroy" do
    let!(:admin) { FactoryGirl.create(:admin) }

    before do
      sign_in admin
    end

    it "should delete a normal user" do
      user = FactoryGirl.create(:user)
      expect { delete user_path(user), {},
       'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
        #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
        to change(User, :count).by(-1)
    end

    it "should not allow the admin to delete herself" do
      expect { delete user_path(admin), {},
       'HTTP_COOKIE' => "remember_token=#{admin.remember_token},
        #{Capybara.current_session.driver.response.headers["Set-Cookie"]}" }.
       to_not change(User, :count)
    end
  end

  # go this from: 
  # http://stackoverflow.com/questions/14640214/how-do-i-redirect-signed-in-users-attempt-to-access-user-new-and-user-create-in
  describe "after signing-in" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    describe "creating a new user" do
      before { get new_user_path }
      specify { response.should redirect_to(root_url) }
    end
  end
end
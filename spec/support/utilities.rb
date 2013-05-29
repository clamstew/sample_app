include ApplicationHelper

def valid_signup(user)
    fill_in "Name",         	with: user.name
    fill_in "Email",        	with: user.email
    fill_in "Password",     	with: user.password
    fill_in "Confirm Password",     with: user.password_confirmation
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

#flash messages - could be a seperate utilities file
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

#HTML attribute - filled in with correct text
RSpec::Matchers.define :have_title_text do |message|
  match do |page|
    page.should have_selector('title', text: message)
  end
end

RSpec::Matchers.define :have_h1_text do |message|
  match do |page|
    page.should have_selector('h1', text: message)
  end
end
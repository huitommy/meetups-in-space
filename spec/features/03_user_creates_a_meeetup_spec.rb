require 'spec_helper'
require 'pry'

feature 'Create a meetup' do
  let(:user) do
    User.create(
      provider: 'github',
      uid: '1',
      username: 'jarlax1',
      email: 'jarlax1@launchacademy.com',
      avatar_url: 'https://avatars2.githubusercontent.com/u/174825?v=3&s=400'
    )
  end

  scenario 'user must be signed before filling in form and hitting submit button' do
    sign_in_as user
    visit '/meetups/new'
    fill_in 'Name', with: 'Football'
    fill_in 'Location', with: 'Boston'
    fill_in 'Description', with: 'play football'
    click_button 'Submit'

    expect(page).to have_content('Football')
    expect(page).to have_content('play football')
    expect(page).to have_content('Boston')
    expect(page).to have_content('Attendants')
  end

  scenario 'user cannot submit without being logged in' do
    visit '/meetups/new'
    fill_in 'Name', with: 'Football'
    fill_in 'Location', with: 'Boston'
    fill_in 'Description', with: 'play football'
    click_button 'Submit'

    expect(page).to have_content('Please sign in before posting any meetups')
    expect(page).to have_content('Add Item')
  end

  scenario 'if user is signed in, they must fill in all fields before submitting or else an error will populate' do
    sign_in_as user
    visit '/meetups/new'
    fill_in 'Name', with: 'Football'
    fill_in 'Location', with: 'Boston'

    click_button 'Submit'
    expect(page).to have_content('Please fill in all form fields')
    expect(page).to have_content('Add Item')
    expect(page).to have_selector("input[value='Football']")
    expect(page).to have_selector("input[value='Boston']")
  end

end

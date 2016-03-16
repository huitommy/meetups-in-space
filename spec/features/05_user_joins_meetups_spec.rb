require 'spec_helper'
require 'pry'

require 'spec_helper'

feature "join meetup" do
  let(:user1) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let(:user2) do
    User.create(
      provider: "github",
      uid: "2",
      username: "jarlax2",
      email: "jarlax2@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "successfully joins meetup" do
    meetup1 = Meetup.create(name: "Ruby Hack Night", description: "Learn to Hack with Ruby", location: "Jupiter", user_id: user1.id)
    MeetupUser.create(user_id: user1.id, meetup_id: meetup1.id, meetup_creator_id: meetup1.user_id)

    visit "/meetups"
    sign_in_as user2
    click_link "Ruby Hack Night"

    expect(page).to have_selector("input[type=submit][value='Join']")

    click_button "Join"

    expect(page).to have_content("You have been added to this meetup.")
    expect(page).to have_content("jarlax2")
  end

  scenario "tries to join meetup not signed in" do
    meetup1 = Meetup.create(name: "Ruby Hack Night", description: "Learn to Hack with Ruby", location: "Jupiter", user_id: user1.id)
    MeetupUser.create(user_id: user1.id, meetup_id: meetup1.id, meetup_creator_id: meetup1.user_id)

    visit "/meetups"
    click_link "Ruby Hack Night"

    expect(page).to have_selector("input[type=submit][value='Join']")

    click_button "Join"

    expect(page).to have_content("Please sign in to join a meetup.")
  end

  scenario "visits show page signed in and already member of event" do
    meetup1 = Meetup.create(name: "Ruby Hack Night", description: "Learn to Hack with Ruby", location: "Jupiter", user_id: user1.id)
    MeetupUser.create(user_id: user1.id, meetup_id: meetup1.id, meetup_creator_id: meetup1.user_id)
    MeetupUser.create(user_id: user2.id, meetup_id: meetup1.id, meetup_creator_id: meetup1.user_id)

    visit "/meetups"
    sign_in_as user2
    click_link "Ruby Hack Night"

    expect(page).to have_no_selector("input[type=submit][value='Join']")
  end


end

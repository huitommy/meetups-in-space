require 'spec_helper'
require 'pry'

feature "Individual Page" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

 scenario "successfully clicks meetup link" do
    meetup1 = Meetup.create(name: "Ruby Hack Night", description: "Learn to Hack with Ruby", location: "Jupiter", user_id: user.id)
    MeetupUser.create(user_id: meetup1.user_id, meetup_id: meetup1.id, meetup_creator_id: meetup1.user_id)

    visit "/meetups"

    click_link "Ruby Hack Night"

    expect(page).to have_content(meetup1.name)
    expect(page).to have_content(meetup1.location)
    expect(page).to have_content(meetup1.description)
    expect(page).to have_content(meetup1.users.first.username)
  end

end

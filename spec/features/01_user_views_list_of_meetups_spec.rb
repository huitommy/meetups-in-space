require 'spec_helper'

feature "Homepage" do

  scenario "meetups listed alphabetically" do
    meetup1 = Meetup.create(name: "Ruby Hack Night", description: "Learn to Hack with Ruby", location: "Jupiter", user_id: 17)
    meetup2 = Meetup.create(name: "Diehard Ruby Night", description: "Ruby Methods Die Hard", location: "Saturn", user_id: 16)

    visit "/meetups"

    expect(page).to have_selector("ul#meetups li:nth-child(1)", text: meetup2.name)
    expect(page).to have_selector("ul#meetups li:nth-child(2)", text: meetup1.name)
 end

  scenario "clicking on the link brings you to a page with a form" do
    visit "/meetups"
    click_link "Post a new meetup"

    expect(page).to have_content("Add Item")
  end

end

require "application_system_test_case"

class MindsTest < ApplicationSystemTestCase
  setup do
    @mind = minds(:one)
  end

  test "visiting the index" do
    visit minds_url
    assert_selector "h1", text: "Minds"
  end

  test "should create mind" do
    visit minds_url
    click_on "New mind"

    fill_in "Name", with: @mind.name
    fill_in "No", with: @mind.no
    click_on "Create Mind"

    assert_text "Mind was successfully created"
    click_on "Back"
  end

  test "should update Mind" do
    visit mind_url(@mind)
    click_on "Edit this mind", match: :first

    fill_in "Name", with: @mind.name
    fill_in "No", with: @mind.no
    click_on "Update Mind"

    assert_text "Mind was successfully updated"
    click_on "Back"
  end

  test "should destroy Mind" do
    visit mind_url(@mind)
    click_on "Destroy this mind", match: :first

    assert_text "Mind was successfully destroyed"
  end
end

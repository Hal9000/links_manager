require "application_system_test_case"

class LinksTest < ApplicationSystemTestCase
  setup do
    @link = links(:one)
  end

  test "visiting the index" do
    visit links_url
    assert_selector "h1", text: "Links"
  end

  test "creating a Link" do
    visit links_url
    click_on "New Link"

    check "Badcert" if @link.badcert
    fill_in "Desc", with: @link.desc
    fill_in "Link", with: @link.link
    fill_in "Score", with: @link.score
    check "Timeout" if @link.timeout
    fill_in "Title", with: @link.title
    click_on "Create Link"

    assert_text "Link was successfully created"
    click_on "Back"
  end

  test "updating a Link" do
    visit links_url
    click_on "Edit", match: :first

    check "Badcert" if @link.badcert
    fill_in "Desc", with: @link.desc
    fill_in "Link", with: @link.link
    fill_in "Score", with: @link.score
    check "Timeout" if @link.timeout
    fill_in "Title", with: @link.title
    click_on "Update Link"

    assert_text "Link was successfully updated"
    click_on "Back"
  end

  test "destroying a Link" do
    visit links_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Link was successfully destroyed"
  end
end

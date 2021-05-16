require "application_system_test_case"

class ChordsTest < ApplicationSystemTestCase
  setup do
    @chord = chords(:one)
  end

  test "visiting the index" do
    visit chords_url
    assert_selector "h1", text: "Chords"
  end

  test "creating a Chord" do
    visit chords_url
    click_on "New Chord"

    fill_in "Artist", with: @chord.artist
    fill_in "Chord1st", with: @chord.chord1st
    fill_in "Chord2nd", with: @chord.chord2nd
    fill_in "Chord3rd", with: @chord.chord3rd
    fill_in "Chord4th", with: @chord.chord4th
    fill_in "Song", with: @chord.song
    click_on "Create Chord"

    assert_text "Chord was successfully created"
    click_on "Back"
  end

  test "updating a Chord" do
    visit chords_url
    click_on "Edit", match: :first

    fill_in "Artist", with: @chord.artist
    fill_in "Chord1st", with: @chord.chord1st
    fill_in "Chord2nd", with: @chord.chord2nd
    fill_in "Chord3rd", with: @chord.chord3rd
    fill_in "Chord4th", with: @chord.chord4th
    fill_in "Song", with: @chord.song
    click_on "Update Chord"

    assert_text "Chord was successfully updated"
    click_on "Back"
  end

  test "destroying a Chord" do
    visit chords_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Chord was successfully destroyed"
  end
end

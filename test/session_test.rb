gem 'minitest'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/session'

class SessionTest<Minitest::Test

  def setup
    @data_cleaner = DataCleaner.new
    @session = Session.new("../event_attendees.csv")
    @content = {
              id: "1",
              regdate: "5/22/86 9:00",
              first_name: "JEFF",
              last_name: "Wan",
              email_address: "Jwan622@gmaIL.com",
              homephone: "718--720-8036",
              state: "NYC",
              street: "31 Hillwood Court",
              zipcode: "103056"
              }


  end

  def test_data_cleaner_homephone_does_not_suck
    assert_equal "7187208036", @data_cleaner.clean_homephone("718-720-8036")
    assert_equal "7187208036", @data_cleaner.clean_homephone("718720-80367")
  end

  def test_data_cleaner_state_does_not_suck
    assert_equal "NY", @data_cleaner.clean_state("NYC")
    assert_equal "state not given", @data_cleaner.clean_state("")
  end

  def test_data_cleaner_street_does_not_suck
    assert_equal "street not given", @data_cleaner.clean_street("")
    assert_equal "103highlanddrive", @data_cleaner.clean_street("103   Highland DRIVE")
  end

  def test_queue_clear_does_not_suck
    session = Session.new("./event_attendees.csv")
    session.load_file
    session.find(:first_name, "Sarah")
    session.queue_clear
    assert_equal session.queue, []
  end

  def test_session_find_and_clear
    session = Session.new("./event_attendees.csv")
    session.load_file

    session.find(:first_name, "Shiyu")
    assert_equal 1, session.queue.count

    session.queue_clear
    session.find(:first_name, "SaraH")

    assert_equal 78, session.queue.count
  end

  def test_sorted_queue_to_tsv
    session = Session.new("./event_attendees.csv")   #this filename will change depending on where I am running the test from terminal. Need to use absolute path.
    session.load_file
    session.find("first_name", "Sarah")
    assert session.sorted_queue_to_tsv("last_name").include?("Abreu\tSarah\thrf001@jumpstartlab.com\t18923\t\tPA\t53shoemakerdrive\t2673422000")
  end

  def test_save_to_csv
    session = Session.new("./event_attendees.csv")
    session.load_file
    session.find("first_name", "SaraH")
    assert session.save_to_csv("./dummy_save.csv")

  end

end

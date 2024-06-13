require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  #  “Let’s test the Home page by issuing a GET request to the Static Pages home URL and then making sure we receive a ‘success’ status code in response.”
  test "should get home" do
    get root_path
    assert_response :success
    # this line checks for the presence of a <title> tag containing the string inside
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
end
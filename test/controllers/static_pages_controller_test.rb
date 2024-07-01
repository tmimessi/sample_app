require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  #  “Let’s test the Home page by issuing a GET request to the Static Pages home URL and then making sure we receive a ‘success’ status code in response.”
  test "should get home" do
    get root_path
    assert_response :success
  end

  test "should get help" do
    get help_path
    assert_response :success
  end

  test "should get about" do
    get about_path
    assert_response :success
  end

  test "should get contact" do
    get contact_path
    assert_response :success
  end
end
require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with valid email/invalid password" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    # simulate a user clicking logout in a second window:
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to @user
    # checking the right redirect target and to actually visit the target page:
    follow_redirect!
    assert_template 'users/show'
    # verifies that the login link disappears by verifying that there are zero login path links on the page:
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "log in with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
  end

  test "log in without remembering" do
    # log in to set the cookie
    log_in_as(@user, remember_me: "1")
    # log in again and verify that the cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end

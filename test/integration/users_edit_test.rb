require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # if a non-logged-in user tries to visit the edit page, after logging in the user will be redirected to /users/1 instead of /users/1/edit. It would be much friendlier to redirect them to their intended destination instead.
  test "successful edit with friendly fowarding" do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    email = "foo@bar.com"
    name = "foo@bar.com"
    # password and confirmation are blank, which is convenient for users who don’t want to update their passwords every time they update their names or email addresses
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" } }
    # checking for a nonempty flash message
    assert_not flash.empty?
    # redirect to the profile page while also verifying that the user’s information correctly changed in the database
    assert_redirected_to @user
    # reload the user’s values from the database and confirm that they were successfully updated
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end

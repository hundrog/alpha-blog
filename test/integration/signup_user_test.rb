require "test_helper"

class SignupTest < ActionDispatch::IntegrationTest
  test "get signup user and create user" do
    get signup_path
    assert_template "users/new"
    assert_difference "User.count", 1 do
      post users_path, params: { user: { username: "new_user", email: "newuser@example.com", password: "password" } }
      assert_response :redirect
      follow_redirect!
    end
    assert_template "articles/index"
  end

  test "invalid user result in failure" do
    get signup_path
    assert_template "users/new"
    assert_no_difference "User.count" do
      post users_path, params: { user: { username: " ", email: " ", password: " " } }
    end
    assert_template "users/new"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
end

require "test_helper"

class CreateArtcilesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "john", email: "joh@example.com", password: "password", admin: true)
  end

  test "get new article and create article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "the title", description: "the description" } }
      assert_response :redirect
      follow_redirect!
    end
    assert_template "articles/show"
    assert_match "the title", response.body
  end

  test "invalid article submission results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: " ", description: " " } }
    end
    assert_template "articles/new"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
end

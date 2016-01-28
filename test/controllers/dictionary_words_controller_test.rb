require 'test_helper'

class DictionaryWordsControllerTest < ActionController::TestCase
  test "should get spellcheck" do
    get :spellcheck
    assert_response :success
  end

end

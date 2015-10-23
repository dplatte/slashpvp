require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get get_character_classes" do
    get :get_character_classes
    assert_response :success
  end

end

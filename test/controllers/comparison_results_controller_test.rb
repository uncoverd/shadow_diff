require 'test_helper'

class ComparisonResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comparison_result = comparison_results(:one)
  end

  test "should get index" do
    get comparison_results_url
    assert_response :success
  end

  test "should get new" do
    get new_comparison_result_url
    assert_response :success
  end

  test "should create comparison_result" do
    assert_difference('ComparisonResult.count') do
      post comparison_results_url, params: { comparison_result: { index: @comparison_result.index, response_id: @comparison_result.response_id, rule_id: @comparison_result.rule_id } }
    end

    assert_redirected_to comparison_result_url(ComparisonResult.last)
  end

  test "should show comparison_result" do
    get comparison_result_url(@comparison_result)
    assert_response :success
  end

  test "should get edit" do
    get edit_comparison_result_url(@comparison_result)
    assert_response :success
  end

  test "should update comparison_result" do
    patch comparison_result_url(@comparison_result), params: { comparison_result: { index: @comparison_result.index, response_id: @comparison_result.response_id, rule_id: @comparison_result.rule_id } }
    assert_redirected_to comparison_result_url(@comparison_result)
  end

  test "should destroy comparison_result" do
    assert_difference('ComparisonResult.count', -1) do
      delete comparison_result_url(@comparison_result)
    end

    assert_redirected_to comparison_results_url
  end
end

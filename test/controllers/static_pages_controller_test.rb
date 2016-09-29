require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
    
   def setup
            @pub_title = "Ruby on Rails Tutorial Sample App"
   end

  test "should get home" do
	get root_url
	assert_response :success
	assert_select "title", @pub_title
   end
  
  test "should get help" do
	get help_url
	assert_response :success
	assert_select "title", "Help | #{@pub_title}"
   end

   test "should get about" do
	get about_url
	assert_response :success
	assert_select "title", "About | #{@pub_title}"
   end

   test "should get contact" do
	get contact_url
	assert_response :success
	assert_select "title", "Contact | #{@pub_title}"
   end
end

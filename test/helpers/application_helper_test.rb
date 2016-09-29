require 'test_helper'
class ApplicationHelperTest < ActionView::TestCase
       
         def setup
           @pub_title = "Ruby on Rails Tutorial Sample App"
           @sub_title = "Help"
           @total_title= "#{@sub_title} | #{@pub_title}"
  	 end

	test "full title helper" do
		assert_equal full_title, @pub_title
		assert_equal full_title("Help"), @total_title
        end
end

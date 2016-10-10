class SessionsController < ApplicationController
  def new
  end

  def create
	 user = User.find_by(email: params[:session][:email].downcase)
	if user && user.authenticate(params[:session][:password])
		log_in user   # 登入用户，然后重定向到用户的资料页面
		remember user
		redirect_to user
#		debugger
        else
	 	# 创建一个错误消息
		 flash.now[:danger] = 'Invalid email/password combination'
		 render 'new'
	 end
  end

  def destroy
     log_out if logged_in?
     redirect_to root_url
  end

end

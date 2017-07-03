class StaticPagesController < ApplicationController
  def home
    if logged_in?#current_user exists only if the user is logged in, so the @micropost variable should only be defined in this case.
    	@micropost = current_user.microposts.build 
    	@feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
end

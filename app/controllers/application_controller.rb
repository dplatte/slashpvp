class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_region
  helper_method :current_bracket

  def current_region
  	if(session[:region_id])
  		@current_region ||= Region.where('id = ?', session[:region_id]).first
  	else
  		@current_region = Region.find_by_abbr('us')
  	end

  	return @current_region
  end

  def current_bracket
    if(session[:bracket_id])
      @current_bracket ||= Bracket.where('id = ?', session[:bracket_id]).first
    else
      @current_bracket = Bracket.find_by_name('3v3')
    end

    return @current_bracket
  end

  def set_region
  	session[:region_id] = params[:region_id]

  	redirect_to :back
  end

  def set_bracket
    session[:bracket_id] = params[:bracket_id]

    redirect_to :back
  end

  def not_found
	 raise ActionController::RoutingError.new('Not Found')
  end
end

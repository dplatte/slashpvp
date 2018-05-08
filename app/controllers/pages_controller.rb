class PagesController < ApplicationController
  def error_404
    render status: 404
  end

  def about
  end
end
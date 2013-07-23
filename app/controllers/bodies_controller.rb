class BodiesController < ApplicationController
  def index
    #@bodies = Body.limit(5)
    @bodies = Body.paginate(page: params[:page])
  end

  def show
  	@body = Body.find(params[:id])
  end
end
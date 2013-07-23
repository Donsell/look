class TelescopesController < ApplicationController
  #defore_action :signed_in_user

  def index
  end

  def create
    @telescope = @current_user.telescopes.build(telescope_params)
    if @telescope.save
      flash[:success] = "Telescope Added!"
      redirect_to root_url
    else
      render 'users/index'
    end
  end

    def destroy
    end

private

    def telescope_params
      params.require(:telescope).permit(:name, :manufacturer, :focal_length, :aperature)
    end
end
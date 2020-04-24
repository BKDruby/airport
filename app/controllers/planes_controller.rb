class PlanesController < ApplicationController
  def show
    @plane = Plane.find(params[:id])
  end
end

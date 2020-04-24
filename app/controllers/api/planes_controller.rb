module Api
  class PlanesController < ApplicationController
    def index
      render json: Plane.all
    end

    def update
      planes_manager.change_plane_status(plane, plane_params[:status])

      head :no_content
    end

    private

    def plane
      @plane ||= Plane.find(params[:id])
    end

    def plane_params
      params.require(:plane).permit(:status)
    end

    def planes_manager
      Planes::ManagerService.instance
    end
  end
end

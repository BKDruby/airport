module Planes
  class ManagerService
    include Singleton

    QUEUE_REDIS_KEY = 'planes_queue'
    PROGRESS_FLAG_REDIS_KEY = 'planes_queue_in_progress'

    def initialize
      @queue_in_progress = false
      super
    end

    def change_plane_status(plane, status)
      ActiveRecord::Base.transaction do
        create_history!(plane, status)
        plane.update!(status: status)
      end

      if status == 'on_take_of'
        queue_for_takeoff(plane.id)
        handle_queue unless queue_in_progress
      end
    end


    def create_history!(plane, status)
      status = status_from_string(status) if status.is_a?(String)

      plane.histories.create!(prev_status: status_from_string(plane.status), new_status: status)
    end

    private

    attr_accessor :queue_in_progress

    def status_from_string(status)
      Plane.statuses[status]
    end

    def queue_for_takeoff(plane_id)
      $redis.rpush(QUEUE_REDIS_KEY, plane_id)
    end

    def handle_queue
      QueueWorker.perform_async unless $redis.get(PROGRESS_FLAG_REDIS_KEY)
    end
  end
end


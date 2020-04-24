module Planes
  class QueueWorker
    include Sidekiq::Worker

    def perform
      $redis.set(ManagerService::PROGRESS_FLAG_REDIS_KEY, true)

      while plane_id = $redis.lpop(ManagerService::QUEUE_REDIS_KEY)
        plane = Plane.find(plane_id)
        wait_for_departure
        manager.create_history!(plane, Plane.statuses[:flew_away])
        plane.update!(status: :flew_away)
      end

      $redis.del(ManagerService::PROGRESS_FLAG_REDIS_KEY)
    end

    private

    def manager
      ManagerService.instance
    end

    def wait_for_departure
      sleep((10..20).to_a.sample)
    end
  end
end
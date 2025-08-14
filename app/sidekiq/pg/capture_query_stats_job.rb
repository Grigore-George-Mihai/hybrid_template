# frozen_string_literal: true

module Pg
  class CaptureQueryStatsJob
    include Sidekiq::Job

    sidekiq_options queue: :maintenance, retry: 3

    def perform
      PgHero.capture_query_stats
    end
  end
end

# frozen_string_literal: true

module Pg
  class ClearQueryStatsJob
    include Sidekiq::Job

    sidekiq_options queue: :maintenance, retry: 3

    def perform
      PgHero.clean_query_stats
    end
  end
end

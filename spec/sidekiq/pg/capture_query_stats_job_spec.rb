# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pg::CaptureQueryStatsJob, type: :job do
  before { described_class.jobs.clear }

  it "enqueues the job" do
    expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1)
  end

  it "calls PgHero.capture_query_stats" do
    allow(PgHero).to receive(:capture_query_stats)

    described_class.new.perform

    expect(PgHero).to have_received(:capture_query_stats)
  end

  it "uses the maintenance queue and retries 3 times" do
    opts = described_class.get_sidekiq_options
    expect(opts["queue"]).to eq(:maintenance)
    expect(opts["retry"]).to eq(3)
  end
end

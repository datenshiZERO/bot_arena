class PrepareBattlesJob < ActiveJob::Base
  queue_as :default

  def perform(arena)
    arena.prepare_battles
  end
end

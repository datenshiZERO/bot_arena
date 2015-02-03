class CommenceBattlesJob < ActiveJob::Base
  queue_as :default

  def perform(arena, unit_ids)
    arena.commence_battle(unit_ids)
  end
end

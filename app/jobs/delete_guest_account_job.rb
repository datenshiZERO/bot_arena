class DeleteGuestAccountJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.destroy if user.guest
  end
end

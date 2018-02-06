module Api::V1

 class ApiController < ApplicationController
  before_action :require_authentication!

  # Métodos globais

  private

  def require_authentication!
    throw(:warden, scope: :user) unless current_user.presence
  end
 end

end

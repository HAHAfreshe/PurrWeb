class Overrides::SessionsController < DeviseTokenAuth::SessionsController
  def render_create_success
    render json: {
          data: resource_data(resource_json: @resource.token_validation_response),
          token: @token.token_hash
    }
  end
end

class ApplicationController < ActionController::API

  rescue_from Exception, with: :rescue_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found

  def health
    render_ok
  end

  private

  def render_ok(res = nil)
    render json: {status: 'ok', payload: res}
  end

  def render_ng(code, message)
    render json: {status: 'ng', error_code: code, message: message}, :status => code
  end

  def rescue_internal_server_error
    render_ng(500, 'internal server error')
  end

  def rescue_not_found
    render_ng(404, 'not found')
  end

end

class ApplicationController < ActionController::API
  def health
    render_ok
  end

  private

  def render_ok(res = nil)
    render json: {status: 'ok', payload: res}
  end

  def render_ng(code, message)
    render json: {status: 'ng', error_code: code, message: message}, :status => :bad_request
  end
end

# The AjaxController is the parent of all AJAX controllers. It provides
# special error handling and some tools to ensure a nice ajaxified day.
class AjaxController < ApplicationController
  before_filter :check_xhr

  skip_before_filter :authorize

  layout false

  respond_to :html, :json

  private

  # Renders an error message and sets the 401 status.
  def unauthorized
    error(t('messages.generics.errors.access'), 401)
  end

  # Renders an error message and sets the 404 status.
  def not_found
    error(t('messages.generics.errors.find'), 404)
  end

  # Renders an error message and sets the 401, if the user is not logged in.
  def authenticate
    unauthorized unless current_user
  end

  # Redirects the user the root url, if this is no ajax request.
  def check_xhr
    redirect_to root_url unless request.xhr?
  end

  # Renders an error message and sets the response status code.
  def error(message, status = 422)
    @message = message

    respond_with(@message) do |format|
      format.json { render status: status }
      format.html { render :error }
    end
  end
end
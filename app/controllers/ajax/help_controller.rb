# The HelpController serves help views. It is intended that they were loaded
# via AJAX, so they were not rendered within a layout.
#
# To add a new help section create the view
# _app/views/help/my_section.html.erb_. You can vistit it at
# _/help/my_section_.
class Ajax::HelpController < AjaxController
  caches_action :show

  # Serves a help section.
  def show
    render params[:id]
  rescue ActionView::MissingTemplate
    raise ActionController::RoutingError, 'Help not found.'
  end

  private

  # Sets a proper cache path.
  def action_cache_path
    super << "/#{params[:id]}"
  end
end
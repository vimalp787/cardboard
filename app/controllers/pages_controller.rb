class PagesController < ApplicationController
  def show
    if params[:id].present?
      @page = Cardboard::Page.find_by_url(params[:id])
    else
      @page = Cardboard::Page.root
    end
    render_main_app_page @page
  end

private

  def edit_link
    cardboard.edit_page_path(@page)
  end
  helper_method :edit_link

  def current_page
    @page
  end
  helper_method :current_page

  def render_main_app_page(page)
    #TODO: Make the layout name variable
    render "pages/#{page.identifier}"#, layout: "layouts/application"
  rescue ActionView::MissingTemplate => e
    @missing_file = e.path
    render "cardboard/pages/error"#, layout: "layouts/application"
  rescue NoMethodError => e
    raise ActionController::RoutingError.new("Page Not Found")
  end
end
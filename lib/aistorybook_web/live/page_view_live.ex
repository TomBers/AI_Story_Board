defmodule AistorybookWeb.PageViewLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS
  alias Aistorybook.Page.Access
  import AistorybookWeb.CoreComponents

  def mount(%{"page_id" => page_id}, _p, socket) do
    page = Access.get_page_by_id(page_id)
    {:ok, assign(socket, page: page)}
  end
end

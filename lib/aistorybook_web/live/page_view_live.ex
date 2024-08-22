defmodule AistorybookWeb.PageViewLive do
  use Phoenix.LiveView
  alias Aistorybook.Page.Access

  def mount(%{"page_id" => page_id}, _p, socket) do
    page = Access.get_page_by_id(page_id)
    {:ok, assign(socket, page: page)}
  end
end

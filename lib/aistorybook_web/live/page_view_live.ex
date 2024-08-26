defmodule AistorybookWeb.PageViewLive do
  use Phoenix.LiveView
  alias Aistorybook.Page.Access

  def mount(%{"page_id" => page_id, "project_name" => project_name}, _p, socket) do
    page = Access.get_page_by_id(page_id)
    {:ok, assign(socket, page: page, project_name: project_name, row_or_col: :row)}
  end

  def handle_event("toggle-output", _p, socket) do
    new_layout =
      if socket.assigns.row_or_col == :row do
        :col
      else
        :row
      end

    {:noreply, assign(socket, row_or_col: new_layout)}
  end
end

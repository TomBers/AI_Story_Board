defmodule AistorybookWeb.BoardLive do
  use Phoenix.LiveView
  import AistorybookWeb.CoreComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

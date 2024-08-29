defmodule AistorybookWeb.StoryEditLive do
  use Phoenix.LiveView
  # import AistorybookWeb.CoreComponents

  def mount(_params, _session, socket) do
    data = %{
      "ops" => [
        %{"attributes" => %{"bold" => true}, "insert" => "fasdsafdsfds "},
        %{"insert" => "dsadsa "},
        %{"attributes" => %{"italic" => true}, "insert" => "dsasd"},
        %{"insert" => " dsadsa\n"}
      ]
    }

    {:ok, assign(socket, data: data)}
  end

  def handle_event("store-text", contents, socket) do
    IO.inspect(contents)
    {:noreply, socket}
  end
end

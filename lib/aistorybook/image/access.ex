defmodule Aistorybook.Image.Access do
  alias Phoenix.PubSub

  def set_image_url(image, url, page_id) do
    image
    |> Ash.Changeset.for_update(:set_img_url, %{url: url})
    |> Ash.update!()

    PubSub.broadcast(Aistorybook.PubSub, "updated_panel", %{page_id: page_id})
  end
end

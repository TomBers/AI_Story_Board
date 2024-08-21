defmodule Aistorybook.Page.GenPanel do
  def gen_image(panel) do
    image = make_image(panel.id, img_gen_req(panel.image_prompt))
    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  defp img_gen_req(_prompt) do
    # TODO - cyle through a few set images
    # https://picsum.photos/id/1/200/300
    {"https://picsum.photos/id/#{Enum.random(1..60)}/200/300", nil}
  end

  defp make_image(panel_id, {url, meta}) do
    Aistorybook.Image.Resources.Image
    |> Ash.Changeset.for_create(:create, %{
      url: url,
      panel_id: panel_id,
      meta: meta
    })
    |> Ash.create!()
  end
end

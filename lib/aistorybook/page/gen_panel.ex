defmodule Aistorybook.Page.GenPanel do
  @api_url "https://api.openai.com/v1/images/generations"
  @api_key System.get_env("OPENAI_API_KEY")

  def gen_image(panel) do
    image = make_placeholder_image(panel)
    spawn(fn -> generate_and_save_img(panel, image) end)
    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  def generate_and_save_img(panel, image) do
    file_name = "#{panel.id}_#{length(panel.images) + 1}.jpg"
    img_gen_req(file_name, panel.prompt, image, &Aistorybook.Image.Access.set_image_url/2)
  end

  def img_gen_req(file_name, prompt, img, save_fn) do
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{@api_key}"}
    ]

    body = %{
      "model" => "dall-e-2",
      "prompt" => prompt,
      "n" => 1,
      "response_format" => "b64_json",
      "size" => "512x512"
    }

    response =
      Req.post!(@api_url,
        headers: headers,
        json: body
      )

    case response.status do
      200 ->
        image_data_base64 = response.body["data"] |> List.first() |> Map.get("b64_json")
        save_image(file_name, image_data_base64, img, save_fn)

      _ ->
        IO.puts("Failed to generate image: #{response.status}")
    end
  end

  defp save_image(file_name, image_data_base64, img, save_fn) do
    body = %{
      "file_name" => file_name,
      "user_id" => 123,
      "img" => image_data_base64
    }

    save_fn.(
      img,
      Req.post!(url: "http://localhost:4000/api/save-image", json: body).body["img_url"]
    )
  end

  def make_placeholder_image(panel) do
    Aistorybook.Image.Resources.Image
    |> Ash.Changeset.for_create(:create, %{
      url: "/images/placeholder.jpg",
      panel_id: panel.id,
      meta: nil
    })
    |> Ash.create!()
  end

  # defp make_image(panel_id, {url, meta}) do
  #   Aistorybook.Image.Resources.Image
  #   |> Ash.Changeset.for_create(:create, %{
  #     url: url,
  #     panel_id: panel_id,
  #     meta: meta
  #   })
  #   |> Ash.create!()
  # end
end

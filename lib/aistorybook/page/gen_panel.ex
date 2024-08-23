defmodule Aistorybook.Page.GenPanel do
  @api_url "https://api.openai.com/v1/images/generations"
  @api_key System.get_env("OPENAI_API_KEY")

  def gen_image(panel) do
    image = make_image(panel.id, img_gen_req(panel.image_prompt))
    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  def img_gen_req(prompt) do
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{@api_key}"}
    ]

    body = %{
      "model" => "dall-e-3",
      "prompt" => prompt,
      "n" => 1,
      "response_format" => "b64_json",
      "size" => "1024x1024"
    }

    response =
      Req.post!(@api_url,
        headers: headers,
        json: body
      )

    case response.status do
      200 ->
        image_data_base64 = response.body["data"] |> List.first() |> Map.get("b64_json")
        file_name = "ChangeMe.jpg"
        {save_image(file_name, image_data_base64), nil}

      _ ->
        IO.puts("Failed to generate image: #{response.status}")
        {"https://picsum.photos/id/#{Enum.random(1..60)}/200/300", nil}
    end
  end

  defp save_image(file_name, image_data_base64) do
    body = %{
      "file_name" => file_name,
      "user_id" => 123,
      "img" => image_data_base64
    }

    Req.post!(url: "http://localhost:4000/api/save-image", json: body) |> IO.inspect()
    # TODO - return the URL of the saved Image
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

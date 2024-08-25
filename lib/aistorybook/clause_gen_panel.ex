defmodule Aistorybook.Page.CaludeGenPanel do
  @moduledoc """
  Handles image generation for story panels.
  """

  require Logger

  alias Aistorybook.Image.Access
  alias Aistorybook.Image.Resources.Image

  @api_url Application.get_env(:aistorybook, :openai_api_url)
  @api_key Application.get_env(:aistorybook, :openai_api_key)
  @image_server_api_key Application.get_env(:aistorybook, :image_server_api_key)
  @image_server_url Application.get_env(:aistorybook, :image_server_url)

  @spec gen_image(map()) :: map()
  def gen_image(panel) do
    image = make_placeholder_image(panel)
    Task.async(fn -> generate_and_save_img(panel, image) end)
    updated_panel = Aistorybook.Page.Access.set_panel_image(panel, image)
    %{updated_panel | images: panel.images ++ [image]}
  end

  @spec generate_and_save_img(map(), map()) :: :ok
  def generate_and_save_img(panel, image) do
    file_name = "#{panel.id}_#{length(panel.images) + 1}.jpg"

    case generate_image_request(file_name, panel.prompt, image) do
      {:ok, img_url} -> Access.set_image_url(image, img_url)
      {:error, reason} -> Logger.error("Failed to generate image: #{reason}")
    end
  end

  @spec generate_image_request(String.t(), String.t(), map()) ::
          {:ok, String.t()} | {:error, String.t()}
  def generate_image_request(file_name, prompt, image) do
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

    case Req.post(@api_url, headers: headers, json: body) do
      {:ok, %{status: 200, body: body}} ->
        image_data_base64 = body["data"] |> List.first() |> Map.get("b64_json")
        save_image(file_name, image_data_base64, image)

      {:ok, %{status: status}} ->
        {:error, "API request failed with status: #{status}"}

      {:error, reason} ->
        {:error, "API request failed: #{inspect(reason)}"}
    end
  end

  @spec save_image(String.t(), String.t(), map()) :: {:ok, String.t()} | {:error, String.t()}
  defp save_image(file_name, image_data_base64, _image) do
    body = %{
      "file_name" => file_name,
      "user_id" => @image_server_api_key,
      "img" => image_data_base64
    }

    case Req.post(url: @image_server_url, json: body) do
      {:ok, %{body: %{"img_url" => img_url}}} ->
        {:ok, img_url}

      {:ok, _} ->
        {:error, "Failed to get image URL from response"}

      {:error, reason} ->
        {:error, "Failed to save image: #{inspect(reason)}"}
    end
  end

  @spec make_placeholder_image(map()) :: map()
  def make_placeholder_image(panel) do
    Image
    |> Ash.Changeset.for_create(:create, %{
      url: "/images/placeholder.jpg",
      panel_id: panel.id,
      meta: nil
    })
    |> Ash.create!()
  end
end

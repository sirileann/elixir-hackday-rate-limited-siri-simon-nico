defmodule ApiCaller do
  @xkcd_url "https://xkcd.com/info.0.json"

  def fetch_latest_comic_image do
    case HTTPoison.get(@xkcd_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, comic} ->
            {:ok, comic["img"]}  # Return the image URL

          {:error, _reason} ->
            {:error, "Failed to parse JSON"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed with status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Failed to fetch comic: #{reason}"}
    end
  end
end

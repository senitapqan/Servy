defmodule First.Parser do
  def parse(request) do
    [method, path, _] =
    request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

      %{method: method, path: path, status: "", resp_body: ""}
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

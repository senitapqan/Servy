defmodule First.Parser do

  alias First.Conv

  def parse(request) when is_bitstring(request) do
    [head,  params_string] = String.split(request, "\r\n\r\n", parts: 2)

    [request_line | headers_lines] = String.split(head, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = handle_params(params_string)
    headers =
      headers_lines |> handle_headers

    %Conv{method: method,
          path: path,
          params: params,
          headers: headers}
  end

  defp handle_params(params) do
    params |> String.trim |> URI.decode_query
  end

  defp handle_headers([]), do: %{}
  defp handle_headers([head | tail]) do
    [key, value] = String.split(head, ": ")

    Map.put(handle_headers(tail), key, value)
  end
end

defmodule OCPropagationStackdriver do
  @moduledoc """
  Conveniences for propagations to and from stackdrivers tracing header "X-Cloud-Trace-Context"
  """
  # GCP Header format: TRACE_ID/SPAN_ID;o=SAMPLED where:
  # TRACE_ID is a 32 character long (lower) hex encoded 128 bit integer
  # SPAN_ID is an unsigned integer
  # SAMPLED is 1 or 0, if the request is beeing sampled or not
  @gcp_header_regex ~r|^(?<trace>[[:alnum:]]{32})/(?<span>[[:digit:]]+);o=(?<sample>[[:digit:]]{1})$|
  @gcp_header "x-cloud-trace-context"

  @doc """
  Get span_ctx from stackdriver header if present.
  """
  def from_headers(headers) do
    headers
    |> Map.get(@gcp_header)
    |> decode()
  end

  @doc """
  Convert a span_ctx to a stackdriver tracing header.
  """
  def to_headers(:undefined), do: %{}
  def to_headers(span_ctx), do: %{@gcp_header => encode(span_ctx)}

  defp encode({:span_ctx, trace_id, span_id, sample, _}) do
    trace_hex =
      trace_id
      |> Integer.to_string(16)
      |> String.pad_leading(32, "0")

    "#{trace_hex}/#{span_id};o=#{sample}"
  end

  defp decode(nil), do: :undefined

  defp decode(header_value) do
    case Regex.named_captures(@gcp_header_regex, header_value) do
      match when is_map(match) ->
        with {trace_id, ""} when is_integer(trace_id) <-
               match
               |> Map.get("trace")
               |> Integer.parse(16),
             {span_id, ""} when is_integer(span_id) <-
               match
               |> Map.get("span")
               |> Integer.parse(10),
             {sample, ""} when is_integer(sample) <-
               match
               |> Map.get("sample")
               |> Integer.parse(10) do
          {:span_ctx, trace_id, span_id, sample, :undefined}
        else
          _ ->
            :undefined
        end

      nil ->
        :undefined
    end
  end
end

defmodule OCPropagationStackdriverTest do
  use ExUnit.Case
  doctest OCPropagationStackdriver

  test "from_headers with valid header" do
    headers = %{
      "x-cloud-trace-context" => "00000000000000000000000000000003/2;o=1"
    }

    assert OCPropagationStackdriver.from_headers(headers) == {:span_ctx, 3, 2, 1, :undefined}
  end

  test "from_headers with invalid header" do
    headers = %{
      "x-cloud-trace-context" => "invalid header"
    }

    assert OCPropagationStackdriver.from_headers(headers) == :undefined
  end

  test "from_headers with missing header" do
    headers = %{}

    assert OCPropagationStackdriver.from_headers(headers) == :undefined
  end

  test "to_headers with span_ctx" do
    assert OCPropagationStackdriver.to_headers({:span_ctx, 3, 2, 1, :undefined}) == %{
             "x-cloud-trace-context" => "00000000000000000000000000000003/2;o=1"
           }

    assert OCPropagationStackdriver.to_headers({:span_ctx, 3, 2, 0, :undefined}) == %{
             "x-cloud-trace-context" => "00000000000000000000000000000003/2;o=0"
           }
  end

  test "to_headers without span_ctx" do
    assert OCPropagationStackdriver.to_headers(:undefined) == %{}
  end
end

defmodule Shippex.AddressTest do
  use ExUnit.Case
  alias Shippex.Address
  doctest Shippex.Address

  test "address shortens the full state" do
    address =
      Shippex.Address.new!(%{
        "name" => "Earl G",
        "address" => "9999 Hobby Ln",
        "city" => "Austin",
        "state" => "Texas",
        "zip" => "78703",
        "country" => "US"
      })

    assert address.state == "US-TX"
    assert address.country == "US"
  end

  test "address handles full country and state names" do
    address =
      Shippex.Address.new!(%{
        "name" => "Earl G",
        "address" => "9999 Hobby Ln",
        "city" => "Austin",
        "state" => "Texas",
        "zip" => "78703",
        "country" => "United States"
      })

    assert address.state == "US-TX"
    assert address.country == "US"
  end

  test "address handles the address formatting" do
    address_line_1 = "9999 Hobby Ln"
    address_line_2 = "Ste 900"

    address =
      Shippex.Address.new!(%{
        "address" => [address_line_1, address_line_2],
        "city" => "Austin",
        "state" => "Texas",
        "zip" => "78703"
      })

    assert address.address == address_line_1
    assert address.address_line_2 == address_line_2
  end

  test "address validates state and country" do
    {:ok, _} =
      Shippex.Address.new(%{
        "address" => "260 Kim Keat Ave",
        "address_line_2" => "#01-01",
        "city" => "Singapore",
        "state" => "SG-01",
        "country" => "SG",
        "zip" => "310260"
      })

    # Valid country, invalid state
    {:error, error} =
      Shippex.Address.new(%{
        "address" => "260 Kim Keat Ave",
        "address_line_2" => "#01-01",
        "city" => "Singapore",
        "state" => "SG-ABCABC",
        "country" => "SG",
        "zip" => "310260"
      })

    assert error =~ ~r/invalid subdivision/i

    # Invalid country, valid state
    {:error, error} =
      Shippex.Address.new(%{
        "address" => "260 Kim Keat Ave",
        "address_line_2" => "#01-01",
        "city" => "Singapore",
        "state" => "SG-01",
        "country" => "SGG",
        "zip" => "310260"
      })

    assert error =~ ~r/invalid country/i
  end
end

defmodule JsonToElixirStructTest do
  use ExUnit.Case
  doctest JsonToElixirStruct

  test "Creating a module file and generate a struct successfully" do
    correct_json_string = "{\"name\":\"dayo\",\"age\":1,\"phone\":08143412400,}"
    module_name_to_be_created = "User"
    assert JsonToElixirStruct.getStringfyJson(correct_json_string,module_name_to_be_created) == :ok
  end

  test "Creating a module file and generate a struct failed" do
    incorrect_json_string = "{\nname\n:\"dayo\",age\n:1,\"phone\":08143412400,}"
    module_name_to_be_created = "User"
    assert JsonToElixirStruct.getStringfyJson(incorrect_json_string,module_name_to_be_created) == {:error,  "error, unable to decode JSON Stringfy object"}
  end

  test "Passing empty single parameter error" do
    module_name_to_be_created = "User"
    assert JsonToElixirStruct.getStringfyJson(module_name_to_be_created) == {:error, "Stringfy Json is required\nModule name is required"}
  end

  test "Passing empty parameter error" do
    module_name_to_be_created = "User"
    assert JsonToElixirStruct.getStringfyJson(module_name_to_be_created) == {:error, "Stringfy Json is required\nModule name is required"}
  end
end

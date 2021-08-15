defmodule JsonToElixirStruct do

  def getStringfyJson(json_string, module_name) do
    case extract_keys_to_struct(json_string) do
      {:ok, struct_keys} -> create_module_and_write_into_file(struct_keys, module_name)
      {:error, msg} -> {:error, msg} 
    end
  end

  def getStringfyJson(_) do
    {:error, "Stringfy Json is required\nModule name is required"} 
  end

  def getStringfyJson() do
    {:error, "Stringfy Json is required\nModule name is required"} 
  end
  
  def convert(json, st) do
    objects = JSON.decode(json)

    case objects do
      {:ok, value} ->
        Enum.map(value, fn object ->
          object =
            Map.new(object, fn {key, value} ->
              {String.to_atom(key), value}
            end)

          struct(st, object)
        end)

      _ ->
        IO.puts("Error!!!")
    end
  end

  def extract_keys_to_struct(object) do
    case JSON.decode(object) do
      {:ok, value} ->
        Map.keys(value)
        |> Enum.map(&checkStructType(&1, value))
        |> Enum.map_join(" ", fn v -> "#{v}" end)
        |> replace_last_comma

      {:error, _} -> {:error,"error, unable to decode JSON Stringfy object"}
        
    end
  end

  defp checkStructType(key, list) do
    struct_key = Map.get(list, key)

    cond do
      is_integer(struct_key) -> key <> ": integers, "
      String.valid?(struct_key) -> key <> ": string, "
      is_float(struct_key) -> key <> ": floats, "
      is_boolean(struct_key) -> key <> ": boolean, "
      is_nil(struct_key) -> key <> ": nil, "
    end
  end

  defp replace_last_comma(value) do
    value = String.replace_suffix(value, ", ", " ")
    {:ok, value}
  end

  defp create_module_and_write_into_file(struct_keys, module_name) do
    fixed_contents = "defmodule #{module_name} do
      defstruct #{struct_keys}
    end"
    File.write("#{module_name}.ex", fixed_contents)
  end
end

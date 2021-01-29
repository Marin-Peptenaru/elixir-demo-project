defmodule Issues.TableFormatter do

  import Enum, only: [map: 2, max: 1, map_join: 3, each: 2]

  def print_table_for(rows, header) do
    with data_by_columns <- split_into_columns(rows, header),
    column_widths <- widths_of(data_by_columns),
    row_format <-format_for(column_widths)
    do
      put_fields_in_columns(header, row_format)
      IO.puts(header_separator(column_widths))
      put_data_in_columns(data_by_columns, row_format)
    end
  end


  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  """
    Initially data is stored in a list of \"JSON objects\", maps in the internal representation.
    So we can think of each element as a row and we can format data to have a list of C lists,
    where C is the number of columns, and each list will contain the values of its respective attribute for
    each element. By storing data like this, it is easier to reason about column widhts and format.
  """

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end


  #map each column to its width
  def widths_of(columns) do
    for column <- columns, do: column |>map(&String.length/1) |> max
  end

  #header separator based on width of each column
  def header_separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-",width) end)
  end

  #return string format for elements
  def format_for(column_widths)  do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end


  def put_fields_in_columns(row, format) do
    :io.format(format, row)
  end

  #puts the data into string columns
  def put_data_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> map(&Tuple.to_list/1) #transform data in tuples, one tuple per element (per row)
    |> each(&put_fields_in_columns(&1, format) )#make the tuples list
  end



end

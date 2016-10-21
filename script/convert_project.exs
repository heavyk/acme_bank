
# alias Experimental.GenStage
# alias Experimental.GenStage.Flow

defmodule ConvertProject do
	@rename_files %{
		"bank" => "poem",
		"customer" => "mun",
	}
	@ex_conversions %{
		"Bank" => "Poem",
		"bank" => "poem",
		"PoemWeb" => "Narrator",
		# perhaps, instead of money -> XP, we should do money ->
		# personal: xp, reputation
		# energy?, gold?, stars?, definable denominations?
		# for something in real-time, maybe an
		# producers, consumers??
		"Money" => "XP",
		# Customer => "Persona"
		"Customer" => "Mun",
		"customer" => "mun",

	}

	@skip_dirs [ ".git", "deps", "_build", ".ctags", "node_modules", "script" ]

  def recursive_rename(dir \\ ".") do
    Enum.each(File.ls!(dir), fn file ->
			fname = "#{dir}/#{file}"
      if File.dir?(fname) do
				# if Enum.member?(@skip_dirs, file) do
				# 	:skip
				# else
				if not (dir === "." and Enum.member?(@skip_dirs, file)) do
					recursive_rename(fname)
				end
			else
				case Path.extname(file) do
					".js" -> do_js(fname)
					".ex" -> do_ex(fname)
					".exs" -> do_ex(fname)
					_ext -> :ok #IO.puts "unknown ext #{ext}"
				end
			end
    end)
  end

  def recursive_replace(dir \\ ".") do
    Enum.each(File.ls!(dir), fn file ->
			fname = "#{dir}/#{file}"
      if File.dir?(fname) do
				# if Enum.member?(@skip_dirs, file) do
				# 	:skip
				# else
				if not (dir === "." and Enum.member?(@skip_dirs, file)) do
					recursive_replace(fname)
				end
			else
				case Path.extname(file) do
					".js" -> do_js(fname)
					".ex" -> do_ex(fname)
					".exs" -> do_ex(fname)
					_ext -> :ok #IO.puts "unknown ext #{ext}"
				end
			end
    end)
  end

	defp do_ex(file) do
		txt = File.stream!(file)
		# this won't work because we compound replacements: BankWeb -> PoemWeb -> Narrator
		# |> Stream.map(&replace(&1, @ex_conversions))
		# so, instead we use Enum.reduce
		|> Stream.map(&Enum.reduce(@ex_conversions, &1, fn {old, new}, str -> String.replace(str, old, new) end))
		|> Enum.join("")
		# IO.puts(txt)
		File.write!(file, txt)
	end

	defp do_js(file) do
		:ok
	end

	# for doing non-reduce string replacements:
	# http://stackoverflow.com/questions/38851439/how-to-replace-a-list-of-the-old-values-with-new-ones-in-a-string
	def replace(string, map) do
    replace(string, map, :binary.compile_pattern(Map.keys(map)), "")
  end

  defp replace(string, map, pattern, acc) do
    case :binary.match(string, pattern) do
      {start, length} ->
        <<before::binary-size(start), match::binary-size(length), rest::binary>> = string
        replacement = map[match]
        replace(rest, map, pattern, acc <> before <> replacement)
      :nomatch ->
        acc <> string
    end
  end
end

ConvertProject.recursive_replace

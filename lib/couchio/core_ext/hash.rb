class Hash
  def stringify_keys
    Hash[*map {|k,v| [k.to_s, v] }.flatten]
  end
end
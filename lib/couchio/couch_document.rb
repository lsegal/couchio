class CouchDocument < CouchIO
  def close
    save
  end
  
  def read
    return @local_copy if @dirty
      
    json = read_json
    verify_ok(json)
    @local_copy = json
  rescue Errno::ENOENT
    @local_copy = {'_id' => File.basename(path)}
  end
  
  def write(data)
    read if !@local_copy
    if @local_copy.is_a?(Hash)
      @local_copy.delete_if {|k,v| !append && k[0,1] != '_' }
    end
      
    if data.is_a?(String) 
      write_string(data)
    elsif data.is_a?(Hash)
      write_hash(data)
    else
      raise ArgumentError, "expecting String or Hash, got #{data.class}"
    end
    @dirty = true
  end
  alias print write
  
  def printf(data, *args)
    write_string sprintf(data, *args)
  end
  
  def write_string(data)
    CouchDocument.new(File.dirname(path), 'a') do |f|
      item = f.read
      item['_attachments'] ||= {}
      
      if append && item['_attachments'][File.basename(path)]
        item['_attachments'][File.basename(path)].update({
          'data' => Base64.b64encode(read.to_s + data.to_s).chomp
        })
      else
        item['_attachments'].update(File.basename(path) => {
          'content_type' => 'text/plain',
          'data' => Base64.b64encode(data).chomp
        })
      end
      f.write(item)
    end
  end
  alias puts write_string
  
  def write_hash(data)
    data = data.stringify_keys
    @local_copy.update(data)
  end
  
  private
  
  def save
    return unless @local_copy && @local_copy.is_a?(Hash)
    
    uri = URI.parse(path)
    Net::HTTP.start(uri.host, uri.port) do |http|
      @local_copy.update('_id' => File.basename(path))
      result = http.send_request('PUT', uri.path, @local_copy.to_json)
      json = JSON.parse(result.body)
      verify_ok(json)
    end
    @dirty = false
  end
end
class AccessError < Exception
end

class CouchIO 
  attr_accessor :path, :readable, :writeable, :append
  
  def initialize(name, mode = 'r', &block)
    @path      = name
    @readable  = mode.include?('r')
    @writeable = mode.include?('w')
    @append    = mode.include?('a')
    
    if block_given?
      yield(self) 
      close
    end
  end
  
  def close; end
  
  def read
    OpenHashStruct.new(read_json)
  end
  
  private
  
  def read_json(extra = nil)
    uri  = extra ? File.join(path, extra) : path
    data = Net::HTTP.get(URI.parse(uri))
    JSON.parse(data)
  rescue JSON::ParserError
    data
  end
  
  def verify_ok(json)
    return unless json.is_a?(Hash)
    return unless json.has_key?('error')
    
    case json['error']
    when 'not_found'
      raise Errno::ENOENT, path
    end
  end
end

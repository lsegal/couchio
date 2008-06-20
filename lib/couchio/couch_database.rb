class CouchDatabase < CouchIO
  include Enumerable
  
  attr_accessor :pos
  alias tell pos
  
  def initialize(*args, &block)
    super
    @pos = 0
  end
  
  def rewind; @pos = 0; self end
  def seek(n) @pos = n; self end
  
  def each 
    rows.each {|row| yield row }
  end
  
  def read
    @rows ||= rows
    result = @rows[@pos]
    @pos += 1
    result
  end
  
  def create
    uri = URI.parse(path)
    Net::HTTP.start(uri.host, uri.port) do |http|
      result = http.send_request('PUT', uri.path)
      json = JSON.parse(result.body)
      verify_ok(json)
    end
    0
  end
  
  def delete
    uri = URI.parse(path)
    Net::HTTP.start(uri.host, uri.port) do |http|
      result = http.delete(uri.path)
      json = JSON.parse(result.body)
      verify_ok(json)
    end
    0
  end
  alias unlink delete
  alias rmdir delete
  
  private
  
  def rows
    if URI.parse(path).path =~ /^\/*$/
      read_json('_all_dbs')
    else
      read_json('_all_docs')["rows"].map {|r| r['id'] }
    end
  end
end
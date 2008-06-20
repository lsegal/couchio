module CouchOpen
  def open(name, mode = 'r', *perm, &block)
    if name.index("couch://") == 0
      couch_io_class.new(name, mode, &block)
    else
      couch_orig_open(name, mode, *perm, &block)
    end
  end
  alias new open
  
  private
  
  def couch_io_class
    case self.to_s
    when 'File'
      CouchDocument
    when 'Dir'
      CouchDatabase
    end
  end
end
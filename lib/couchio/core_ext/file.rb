class << File
  alias couch_orig_open open
  alias couch_orig_new new
  include CouchOpen
  
  alias couch_orig_read read
  def read(filename)
    if filename.index("couch://") == 0
      CouchDocument.new(filename).read
    else
      couch_orig_read
    end
  end
end
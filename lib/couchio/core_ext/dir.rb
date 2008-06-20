class << Dir
  alias couch_orig_open open
  alias couch_orig_new new
  remove_method :open
  include CouchOpen
  
  alias couch_orig_entries entries
  def entries(dirname)
    if dirname.index("couch://") == 0
      CouchDatabase.new(dirname).map
    else
      couch_orig_entries(dirname)
    end
  end

  alias couch_orig_foreach foreach
  def foreach(dirname, &block)
    if dirname.index("couch://") == 0
      CouchDatabase.new(dirname).each {|f| yield f }
    else
      couch_orig_foreach(dirname, &block)
    end
  end

  alias couch_orig_rmdir rmdir
  def rmdir(dirname)
    if dirname.index("couch://") == 0
      CouchDatabase.new(dirname).delete
    else
      couch_orig_rmdir(dirname)
    end
  end
  alias unlink rmdir
  alias delete rmdir

  alias couch_orig_mkdir mkdir
  def mkdir(dirname, *args)
    if dirname.index("couch://") == 0
      CouchDatabase.new(dirname).create
    else
      couch_orig_mkdir(dirname, *args)
    end
  end
end
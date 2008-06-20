CouchIO for Ruby
================

Written by Loren Segal in 2008, licensed under MIT license.


SYNOPSYS
--------

CouchIO is a simple VFS for Ruby, adding support to open, read and write
CouchDB resource URI's as if they were local files. The API intuitively uses
the existing `File` and `Dir` API to read and write. The goal is to emulate
Ruby's `Dir` and `File` implementation for the filesystem completely. Not all of 
the interface has been implemented, but basic read/write support is currently 
available. In addition to database support, CouchIO has support for both documents 
and attachments. 


USAGE
-----

### Accessing Databases & Documents ###

In CouchIO, the `Dir` filesystem equivalent of a directory is a CouchDB database.
The equivalent of a `File` is a CouchDB document _or_ a CouchDB attachment, depending
on how the data is written.

The only difference between accessing files and directories and accessing documents and
databases is that you need to specify the full URI including the "couch://" scheme prefix,
not "http://" (to differentiate from `open-uri` support).

### Writing Documents & Attachments ###

Like with writing to files, you need to use the 'a' append mode flag if you wish to append
to the file. If you do not use this for a Couch resource, it will overwrite all of your contents.

To write data to a document, your data **must** be a `Hash`. To write data to an _attachment_,
your data must be a `String`. As you will see in the examples, writing a string will force
the resource to be saved as an attachment while writing hash contents will save it as a document.

### Note About Saving ###

Saving is done when the file is closed. There is a `save` method that can be manually called, 
however, to maintain filesystem independence, it should never be called.


EXAMPLES
--------

List databases:

    Dir.entries("couch://localhost:5984/") #=> ['todo', 'test']
    
Create a database:

    Dir.mkdir("couch://localhost:5984/xyzzy")
    
Delete a database:

    Dir.unlink("couch://localhost:5984/xyzzy")
  
List documents in a database:

    Dir.entries("couch://localhost:5984/todo") #=> ['fix_car', 'wash_dishes', ...]
    # - OR -
    Dir.open("couch://localhost:5984/todo").each do |p|
      puts p
    end
  
Open and read a document:

    File.open("couch://localhost:5984/todo/fix_car").read 
    #=> {'_id' => 'fix_car', 'text' => 'Need to fix car!', 'time' => 'June 20th 2008 10:55AM'}
    # Same as: File.read("couch://localhost:5984/todo/fix_car")
  
Open a document for append-writing:

    File.open("couch://localhost:5984/todo/fix_car", 'wa') do |f|
      f.write 'text' => 'Need to fix car NOW!!!'
    end
    File.read("couch://localhost:5984/todo/fix_car")
    #=> {'_id' => 'fix_car', 'text' => 'Need to fix car NOW!!!', 'time' => 'June 20th 2008 10:55AM'}
  
Write an attachment (document must exist):

    File.open("couch://localhost:5984/test/doc/foo.txt", 'w') do |f|
      f.write "hello world"
    end
  
Read an attachment:

    File.read("couch://localhost:5984/test/doc/foo.txt") #=> "hello world"
  
  
COPYRIGHT
---------

CouchIO is free software written by **Loren Segal** under the MIT license. If
you meet him, give him props.
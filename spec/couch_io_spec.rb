require File.dirname(__FILE__) + '/../lib/couchio'

describe CouchDocument, '#read' do
  it "should read a couch file" do
    Net::HTTP.stub!(:get).and_return('{"a":1, "b":2, "_id":"foo"}')
    CouchDocument.new("couch://localhost/file").read.should == {'a' => 1, 'b' => 2, '_id' => 'foo'}
    CouchDocument.new("couch://localhost/file").read
  end
end

describe CouchDocument, '#write' do
  it "should write-append a couch file with 'a'" do
    req = mock('request')
    resp = mock('response')
    resp.stub!(:body).and_return('{"ok":"true"}')
    req.should_receive(:send_request).with("PUT", "/file", "{\"a\":2,\"b\":2,\"_id\":\"file\"}").and_return(resp)
    Net::HTTP.stub!(:get).and_return('{"a":1, "b":2, "_id":"foo"}')
    Net::HTTP.should_receive(:start).and_yield(req)
    CouchDocument.new("couch://localhost/file", 'a') do |f|
      f.write 'a' => 2
    end
  end

  it "should overwrite a couch file without 'a'" do
    req = mock('request')
    resp = mock('response')
    resp.stub!(:body).and_return('{"ok":"true"}')
    req.should_receive(:send_request).with("PUT", "/file", "{\"a\":2,\"_id\":\"file\"}").and_return(resp)
    Net::HTTP.stub!(:get).and_return('{"a":1, "b":2, "_id":"foo"}')
    Net::HTTP.should_receive(:start).and_yield(req)
    CouchDocument.new("couch://localhost/file") do |f|
      f.write 'a' => 2
    end
  end
end
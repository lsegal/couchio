Net::HTTP.version_1_2

module URI
  @@schemes['COUCH'] = URI::HTTP
end
#run "sed -i.BK 's/URL/foo/g' #{release_path}/lib/test_url.rb"
#raise "error on deploy hook"
#run "sed -i.BK 's/URL/http:\/\/localhost:3000\/foo/g' #{release_path}/lib/test_url.rb"

on_app_servers_and_utilities do
  foobar
end

def foobar
  run "sed -i.BK 's/URL/http\\/\\//g' #{release_path}/lib/test_url.rb"
end


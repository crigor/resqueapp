#run "sed -i.BK 's/URL/foo/g' #{release_path}/lib/test_url.rb"
#raise "error on deploy hook"
#run "sed -i.BK 's/URL/http:\/\/localhost:3000\/foo/g' #{release_path}/lib/test_url.rb"

def foobar
  run "sed -i.BK 's/URL/http\\/\\//g' #{release_path}/lib/test_url.rb"
end

on_app_servers_and_utilities do
  #foobar
end

run "curl -sS http://localhost/nr -X POST -H \"X-Api-Key: foobaz\""


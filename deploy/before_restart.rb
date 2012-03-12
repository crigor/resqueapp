#run "sed -i.BK 's/URL/foo/g' #{release_path}/lib/test_url.rb"
run "sed -i.BK 's/URL/http\/\//foo/g' #{release_path}/lib/test_url.rb"
#run "sed -i.BK 's/URL/http:\/\/localhost:3000\/foo/g' #{release_path}/lib/test_url.rb"

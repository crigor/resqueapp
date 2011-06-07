def bundle
  if File.exist?("#{c.release_path}/Gemfile")
    info "~> Gemfile detected, bundling gems"
    lockfile = File.join(c.release_path, "Gemfile.lock")

    bundler_installer = if File.exist?(lockfile)
                          get_bundler_installer(lockfile)
                        else
                          warn_about_missing_lockfile
                          bundler_09_installer(default_09_bundler)
                        end

    sudo "#{$0} _#{EY::Serverside::VERSION}_ install_bundler #{bundler_installer.version}"

    ####################################################
    # this is the only line that has been changed:
    #run "cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}"
    run "exec ssh-agent bash -c 'ssh-add /home/crigor/.ssh/#{c.app}-deploy-key && cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}'"
  end
end

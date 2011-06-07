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

    @git_ssh = File.open("/tmp/git-ssh", "w")
    @gsc = File.open("/tmp/git-ssh-config", "w")

    @gsc.write "StrictHostKeyChecking no\n"
    @gsc.write "CheckHostIP no\n"
    @gsc.write "PasswordAuthentication no\n"
    @gsc.write "LogLevel DEBUG\n"
    @gsc.write "IdentityFile ~/.ssh/#{c.app}-deploy-key\n"
    @gsc.chmod(0600)
    @gsc.close

    @git_ssh.write "#!/bin/sh\n"
    @git_ssh.write "unset SSH_AUTH_SOCK\n"
    @git_ssh.write "ssh -F \"/tmp/git-ssh-config\" $*\n"
    @git_ssh.chmod(0700)
    # NB: this file _must_ be closed before git looks at it.
    #
    # Linux won't let you execve a file that's open for writing,
    # so if this file stays open, then git will complain about
    # being unable to exec it and will exit with a message like
    #
    # fatal: exec /tmp/git-ssh20100417-21417-d040rm-0 failed.
    @git_ssh.close

    #ENV['GIT_SSH'] = @git_ssh.path

    ####################################################
    # this is the only line that has been changed:
    #run "cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}"
    run "GIT_SSH=/tmp/git-ssh cd /data/resqueapp/current && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}'"
    #run "GIT_SSH=/tmp/git-ssh cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}'"
    #run "exec ssh-agent bash -c 'ssh-add /home/crigor/.ssh/#{c.app}-deploy-key && cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}'"
  end
end

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

    @git_ssh = Tempfile.open("git-ssh")
    @config = Tempfile.open("git-ssh-config")

    @config.write "StrictHostKeyChecking no\n"
    @config.write "CheckHostIP no\n"
    @config.write "PasswordAuthentication no\n"
    @config.write "LogLevel DEBUG\n"
    @config.write "IdentityFile ~/.ssh/#{c.app}-deploy-key\n"
    @config.chmod(0600)
    @config.close

    @git_ssh.write "#!/bin/sh\n"
    @git_ssh.write "unset SSH_AUTH_SOCK\n"
    @git_ssh.write "ssh -F \"#{@config.path}\" $*\n"
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
    run "GIT_SSH=#{@git_ssh.path} cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}'"
    #run "exec ssh-agent bash -c 'ssh-add /home/crigor/.ssh/#{c.app}-deploy-key && cd #{c.release_path} && bundle _#{bundler_installer.version}_ install #{bundler_installer.options}'"
  end
end

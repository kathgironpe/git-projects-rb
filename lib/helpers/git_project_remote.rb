# Mostly methods for checking/ adding new remotes
module GitProjectRemote
  def self.included(base)
    base.extend ClassMethods
  end

  # Check/ add new remotes
  module ClassMethods
    # Clone unless dir exists
    def clone(url, name, path)
      r = "#{path}/#{name}"
      if Git.open(r)
        puts 'Already cloned '.yellow + "#{url}".blue
      else
        Git.clone(url, name, path: path) || Git.init(r)
        g = Git.open(r)
        puts "Cloning #{url} as #{name} into #{path}".green
      end
      g
    end

    def fetch(g)
      g.remotes.each do |r|
        next if %w(root_dir all group).include?(r.name)
        r.fetch
        puts "Fetching updates from #{r.name}: #{r.url}".green
      end
    end

    def remote_exists?(g, name)
      g.remotes.map(&:name).include?(name)
    end

    def add_new_remote(g, name, remote)
      g.add_remote(name, remote)
      g.add_remote('all', remote) unless remote_exists?(g, name)
      `git remote set-url --add all #{remote}`
      puts "Added remote #{name}".green
    end

    # Add remote
    def add_remote(g, v)
      g.add_remote('origin', v['origin']) unless remote_exists?(g, 'origin')
      g.add_remote('all', v['origin']) unless remote_exists?(g, 'all')
      v.each do |name, remote|
        next if  %w(root_dir all group).include?(name) ||
          g.remotes.map(&:name).include?(name)
        add_new_remote(g, name, remote)
      end
    end
  end
end

class GithubNotifier
    attr_reader :commit

    def initialize(commit)
        @commit = commit
        update_status
    end
    
    private
    
    def update_status
        Octokit.create_status(@commit.repo, @commit.commit_hash, @commit.github_status,
                          :context => 'Request shadowing',
                          :description => @commit.github_description)
    end    
end    
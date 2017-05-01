Octokit.configure do |c|
  c.login = 'uncoverd'
  c.password = ENV['GITHUB_TOKEN']
end
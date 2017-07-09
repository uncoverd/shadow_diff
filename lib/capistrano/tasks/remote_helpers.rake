def db_info
  db_config = capture("cat /home/#{fetch(:deploy_user)}/#{fetch(:application)}/current/config/database.yml")
  YAML::load(db_config)
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

def environment_is?(environment_name)
  set (:ident), -> { fetch(:identifier) }
  fetch(:ident) == environment_name
end

def db_name
  db_info['production']['database']
end

def db_user
  db_info['production']['user']
end

def access_key_id
  capture('echo $ACCESS_KEY_ID').strip
end

def secret_access_key
  capture('echo $SECRET_ACCESS_KEY').strip
end
require 'net/ssh'

COMMANDS = {:full_update => 'bucardo update sync the_sync onetimecopy=2',
            :reload_sync => 'bucardo reload the_sync',
            :status => 'bucardo status the_sync',
            :stop => 'bucardo stop',
            :start => 'bucardo start',
            :wait => 'sleep 5',
            :truncate_slave => 'su - postgres -c \'psql -U postgres -d jaka_db -c "truncate public.microposts, public.users, public.relationships, public.schema_migrations"\''
            }
slave_ip = '188.166.15.157'
master_ip = '128.199.59.160'

time = Time.now
Net::SSH.start(slave_ip, 'root') do |ssh|
    [:truncate_slave].each do |command|
        puts "Running command " + command.to_s
        output = ssh.exec!(COMMANDS[command])
        puts output
    end    
end

Net::SSH.start(master_ip, 'root') do |ssh|
    [:status, :full_update, :reload, :stop, :wait, :start, :status].each do |command|
        puts "Running command " + command.to_s
        output = ssh.exec!(COMMANDS[command])
        puts output
    end    
    puts Time.now - time
end

#add before_action to application_controller to clear activerecord id

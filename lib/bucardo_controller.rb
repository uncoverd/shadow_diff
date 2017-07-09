class BucardoController
    attr_accessor :master_ip, :slave_ip

    COMMANDS = {
            :full_update => 'bucardo update sync the_sync onetimecopy=2',
            :reload_sync => 'bucardo reload the_sync',
            :status => 'bucardo status the_sync',
            :stop => 'bucardo stop',
            :start => 'bucardo start',
            :wait => 'sleep 5',
            :truncate_slave => 'su - postgres -c \'psql -U postgres -d jaka_db -c "truncate public.microposts, public.users, public.relationships, public.schema_migrations"\''
    }

    def initialize(master_ip, slave_ip)
        @master_ip = master_ip
        @slave_ip = slave_ip
    end

    def reset_slave_db
        truncate_slave_db
        sync_slave_db
    end

    private

    def truncate_slave_db
        Net::SSH.start(@slave_ip, 'root') do |ssh|
        [:truncate_slave].each do |command|
            puts "Running command " + command
            output = ssh.exec!(COMMANDS[command])
            puts output
        end    
    end

    def sync_slave_db
       Net::SSH.start(@master_ip, 'root') do |ssh|
            [:status, :full_update, :reload, :stop, :wait, :start, :status].each do |command|
                puts "Running command " + command.to_s
                output = ssh.exec!(COMMANDS[command])
                puts output
            end    
        end 
    end    

#add before_action to application_controller to clear activerecord id
end
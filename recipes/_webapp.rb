env = nil
case node.chef_environment
  when "production"
    env = "PRD"
    domain = "EGISTICS"
  when "uat"
    env = "UAT"
    domain = "EGISTICS"
  when "development"
    env = "DEV"
    domain = "EGDEV"
  when "staging"
    env = "PRD"
    domain = "EGISTICS"
  when "test"
    env = "TST"
    domain = "EGISTICS"
  else
    env = "PRD"
    domain = "EGISTICS"
end

web_db_item = data_bag_item('web',"#{env}_fdc")

webapps = node.assigned_webapps

webapps.each do |webapp|
    if webapp.downcase.include?('fdc')
        #Recipe variables
        zip_path = win_friendly_path(
                     ::File.join(
                       web_db_item[webapp]['artifact_path'],
                    #  "/#{web_db_item[webapp]['build']}/",
                       web_db_item[webapp]['artifact_filename']
                      )
                    )

        web_root = win_friendly_path(
                     ::File.join(
                       web_db_item[webapp]['docroot'],
                       web_db_item[webapp]['web_directory']
                      )
                    )

        app_root = win_friendly_path(
                    ::File.join(
                       web_db_item[webapp]['docroot'],
                       web_db_item[webapp]['app_directory']
                      )
                    )

        redirect_file = win_friendly_path(
        			::File.join(web_root, 'default.htm')
        			)

        site_name = web_db_item[webapp]['site_name']
        app_name = web_db_item[webapp]['app_name']
        server_name = node.name
        minutes = (server_name[11..12].to_i * 3).to_s
        minutes = "0" + minutes if minutes.length < 2
        webpass = Chef::EncryptedDataBagItem.load("web", "webpass")
        IntegratedPipeline = web_db_item[webapp]['ManagedPipelineMode'] ? :Integrated : :Classic

        #Config variables
        config = {
        	:baseapp => (web_db_item[webapp]['baseapp'] ? true : false),
        	:zipfile => {
        	:artifact_source => zip_path
        	},
        	:site_name => site_name,
        	:site => {
        	:name => site_name,
        	:docroot => web_root
        	},
        	:pool => {
        	:name => web_db_item[webapp]['app_pool'],
        	:private_mem => 1000000,
        	:recycle_at_time => web_db_item[webapp]['recycle_pool'] ? ("01:" + minutes + ":00") : nil,
        	:identity => "#{domain}\\#{web_db_item[webapp]['pool_identity']}"
        	},
        	:app => {
        	:physical_path => app_root,
        	:app_pool => web_db_item[webapp]['app_pool'],
        	:web_config_source => web_db_item[webapp]['config_filepath']
        	},
        	:log => {
        	:path => web_db_item[webapp]['LogPath'],
        	:max_size => "3MB"
          },
          :build => "#{web_db_item[webapp]['build']}"
        }

      #Step 1. Remove Default Web Site and set server logging

      include_recipe "egistics_iis::default"
      include_recipe "iis::remove_default_site"


      #Step 2. Add feature WCF-NonHTTP-Activation

      windows_feature 'WCF-NonHTTP-Activation' do
      	action :install
      	source node['egistics']['windows']['feature']['dism_source']
      end

      #Step 3. Create application pool for web site

      iis_pool web_db_item[webapp]['site_pool'] do
      	runtime_version '4.0'
      	pipeline_mode :Integrated
      	idle_timeout '00:00:00'
      	recycle_after_time '00:00:00'
      	pool_username config[:pool][:identity]
      	action [:add, :config]
      	notifies :run, "execute[#{web_db_item[webapp]['site_pool']}]", :immediately
      end

      #Step 4. Create web site and configure default documents
      iis_binding = web_db_item[webapp]['binding']

      if node[:tags].include?("ashburn") then
          if node.role?("xer_app") then
            iis_binding = "net.tcp/808:*,https/*:443:AP-XER-SPX-01.tisa.io"
          else
            iis_binding.gsub!(/(:[dD][pP])/, 'AP')
            iis_binding.gsub!(/(:[dD][uU])/, 'AU')
          end
      elsif node[:tags].include?("dallas")
        if node.role?("xer_app") && env == "uat" then
            iis_binding = "net.tcp/808:*,https/*:443:DU-XER-SPX-01.tisa.io"
          elsif node.role?("xer_app") then
            iis_binding = "net.tcp/808:*,https/*:443:DP-XER-SPX-01.tisa.io"
          end
       end

      iis_site site_name do
      	site_id web_db_item[webapp]['IIS_SiteID']
      	application_pool web_db_item[webapp]['site_pool']
      	path web_root
      	bindings iis_binding
      	action [:add, :start]
      	notifies :run, 'powershell_script[set_sslcert]', :delayed
      end

      #iis_config "/section:defaultDocument /enabled:true /+files.[value='default.htm,default.asp,default.aspx,index.htm,index.html']" do
      #	action :config
      #end

      #Step 5. Create applicatoin pool for application

      iis_pool config[:pool][:name] do
      	runtime_version web_db_item[webapp]['ASPNet4'] ? '4.0' : '2.0'
      	pipeline_mode IntegratedPipeline
      	idle_timeout '00:00:00'
      	recycle_after_time '00:00:00'
      	private_mem config[:pool][:private_mem] if config[:pool][:private_mem]
      	recycle_at_time config[:pool][:recycle_at_time] if config[:pool][:recycle_at_time]
        thirty_two_bit web_db_item[webapp]['thirty_two_bit']
      	pool_username config[:pool][:identity]
      	action [:add, :config]
      	notifies :run, "execute[#{config[:pool][:name]}]", :immediately
      end

      #Step 6. Create application

      iis_app site_name do
      	path "#{app_name}"
      	physical_path config[:app][:physical_path]
      	application_pool config[:pool][:name]
      	enabled_protocols "https,net.tcp"
      	action [:add, :config]
      	notifies :run, "execute[#{site_name}#{app_name}]"
      end

      #Step 7. Create directories for web site and application paths
      # Add all of the directories to the list
      folders = Array.new

      [ web_root, app_root, config[:log][:path] ].each do |node|
        if node.is_a?(Array)
          folders += node
        else
          folders << node
        end
      end

      if node[:tags].include?("ashburn")
          folders.each do |s|
              s.gsub!(/[dD][pP]/, 'AP')
          end
      end

      #create the folders on the file system
      folders.each do |dir|
        directory dir do
            recursive true
            inherits true
            rights :modify, "#{domain}\\SS 1", :applies_to_children => true
            rights :modify, web_db_item[webapp]['pool_identity'], :applies_to_children => true
          end
      end

      #Step 8. Copy redirect html file to the docroot of web site and hc.aspx to app_root

      template redirect_file do
      	action :create
      	source 'default.htm.erb'
      	#cookbook 'egistics_storageproxy'
      	variables({
      			:url => web_db_item[webapp]['redirect_url']
      			})
      end

      template "#{app_root}/hc.aspx" do
      	action :create
      	source 'hc.aspx.erb'
      end

      #Step 9. Move binaries and web.config to application path

      windows_zipfile app_root do
      	source zip_path
      	action :unzip
      	overwrite true
      	notifies :restart, "iis_pool[#{config[:pool][:name]}]"
      	not_if { ::File.exists?("#{app_root}/web.config") || web_db_item[webapp]['baseapp'] }
      end

      #Split Site and Environment from node name
      name = node.name
      site, environment = name[0..1][0], name[0..1][1]

      template "#{app_root}/web.config" do
      	source "#{web_db_item[webapp]['web_config']}.erb"
      	action :create
      	variables({
      		:strongauth => web_db_item[webapp]['strongauth'],
          :site => site,
          :env => environment,
          :storage_proxy => node[:tags].include?("ashburn") ? 'https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-E1/synapticWebService.asmx' : 'https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-E1/synapticWebService.asmx'
      		})
      	notifies :restart, "iis_pool[#{config[:pool][:name]}]"
      end

      #Copy Assets from Golden Repository
      if web_db_item[webapp]['assets']
          powershell_script "CopyImages" do
          guard_interpreter :powershell_script
          code "robocopy \\\\DP-ESL-EFS-01\\GOLDREP\\Assets\\#{env}\\FDC\\#{web_db_item[webapp]['app_directory']}\\images #{app_root}\\Images /MIR /W:1 /R:1 /LOG:#{config[:log][:path]}\\ImagesCopy.txt
          exit $LASTEXITCODE"
        end

        powershell_script "CopyManuals" do
          guard_interpreter :powershell_script
          code "robocopy \\\\DP-ESL-EFS-01\\GOLDREP\\Assets\\#{env}\\FDC\\#{web_db_item[webapp]['app_directory']}\\manuals #{app_root}\\Content\\Manuals /MIR /W:1 /R:1 /LOG:#{config[:log][:path]}\\ManualsCopy.txt
          exit $LASTEXITCODE"
        end
      end

      #Support resources to assign ssl cert to web site, and additional configs for application pools and application

      powershell_script "set_sslcert" do
      	code <<-EOH
      	$cert_thumb = (get-childitem Cert:/LocalMachine/My | where-object {$_.Subject -MATCH $env:COMPUTERNAME+".egistics.local"}).Thumbprint
      	netsh http add sslcert ipport=0.0.0.0:443 certhash="$cert_thumb" appid="{4dc3e181-e14b-4a21-b022-59fc669b0914}" verifyclientcertrevocation=disable
      	EOH
      	action :nothing
      	ignore_failure true
      end

      execute "#{web_db_item[webapp]['site_pool']}" do
      	command "#{node[:iis][:home]}\\appcmd.exe set apppool \"#{web_db_item[webapp]['site_pool']}\" /autoStart:true /startMode:AlwaysRunning"
      	action :nothing
      end

      execute "#{config[:pool][:name]}" do
      	command "#{node[:iis][:home]}\\appcmd.exe set apppool \"#{config[:pool][:name]}\" /autoStart:true /startMode:AlwaysRunning"
      	action :nothing
      end

      execute "#{site_name}#{app_name}" do
      	command "#{node[:iis][:home]}\\appcmd.exe set app \"#{site_name}#{app_name}\" /preloadEnabled:true"
      	action :nothing
      end
    end
end

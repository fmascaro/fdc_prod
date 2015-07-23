::Chef::Recipe.send(:include, Windows::Helper)

#Recipe variables
zip_path = win_friendly_path(
             ::File.join(
               node[:egistics][:fdc_web_service][:artifact_path],
               node[:egistics][:fdc_web_service][:artifact_filename]
              )
            )

web_root = win_friendly_path(
             ::File.join(
               node[:egistics][:fdc_web_service][:docroot],
               node[:egistics][:fdc_web_service][:web_directory]
              )
            )

app_root = win_friendly_path(
            ::File.join(
               node[:egistics][:fdc_web_service][:docroot],
               node[:egistics][:fdc_web_service][:app_directory]
              )
            )

redirect_file = win_friendly_path(
			::File.join(web_root, 'default.htm')
			)

site_name = node[:egistics][:fdc_web_service][:site_name]
app_name = node[:egistics][:fdc_web_service][:app_name]
server_name = node.name
minutes = (server_name[11..12].to_i * 3).to_s
minutes = "0" + minutes if minutes.length < 2

#Config variables
config = {
	:baseapp => (node[:egistics][:fdc_web_service][:baseapp] ? true : false),
	:zipfile => {
	:artifact_source => zip_path
	},
	:site_name => site_name,
	:site => {
	:name => site_name,
	:docroot => web_root
	},
	:pool => {
	:name => node[:egistics][:fdc_web_service][:app_pool],
	:private_mem => 600000,
	:recycle_at_time => node[:egistics][:fdc_web_service][:recycle_pool] ? ("01:" + minutes + ":00") : nil,
	:identity => node[:egistics][:fdc_web_service][:pool_identity]
	},
	:app => {
	:physical_path => app_root,
	:app_pool => node[:egistics][:fdc_web_service][:app_pool],
	:web_config_source => node[:egistics][:fdc_web_service][:config_filepath]
	},
	:log => {
	:path => node[:egistics][:fdc_web_service][:log_path],
	:max_size => "3MB"
	}
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

iis_pool node[:egistics][:fdc_web_service][:site_pool] do
	runtime_version '4.0'
	pipeline_mode :Integrated
	idle_timeout '00:00:00'
	recycle_after_time '00:00:00'
	pool_username node[:egistics][:fdc_web_service][:pool_identity]
	action [:add, :config]
	notifies :run, "execute[config_#{node[:egistics][:fdc_web_service][:site_pool]}]", :immediately
end

#Step 4. Create web site and configure default documents

iis_site site_name do
	site_id 7
	application_pool node[:egistics][:fdc_web_service][:site_pool]
	path web_root
	bindings node[:egistics][:fdc_web_service][:binding]
	action [:add, :start]
	notifies :run, 'powershell_script[set_sslcert]', :delayed
end

#iis_config "/section:defaultDocument /enabled:true /+files.[value='default.htm,default.asp,default.aspx,index.htm,index.html']" do
#	action :config
#end

#Step 5. Create applicatoin pool for application

iis_pool config[:pool][:name] do
	runtime_version node[:egistics][:fdc_web_service][:runtime_v4] ? '4.0' : '2.0'
	pipeline_mode node[:egistics][:fdc_web_service][:pipline_mode]
	idle_timeout '00:00:00'
	recycle_after_time '00:00:00'
	private_mem config[:pool][:private_mem] if config[:pool][:private_mem]
	recycle_at_time config[:pool][:recycle_at_time] if config[:pool][:recycle_at_time]
	pool_username config[:pool][:identity]
	action [:add, :config]
	notifies :run, "execute[config_#{config[:pool][:name]}]", :immediately
end

#Step 6. Create application

iis_app site_name do
	path "#{app_name}"
	physical_path config[:app][:physical_path]
	application_pool config[:pool][:name]
	enabled_protocols "https,net.tcp"
	action [:add, :config]
	notifies :run, "execute[config_#{site_name}#{app_name}]"
end

#Step 7. Create directories for web site and application paths

[ web_root, app_root, config[:log][:path] ].each do |dir|
	directory dir do
		recursive true
		inherits true
		rights :modify, "EGISTICS\\SS 1", :applies_to_children => true
	end
end

#Step 8. Copy redirect html file to the docroot of web site and hc.aspx to app_root

template redirect_file do
	action :create
	source 'default.htm.erb'
	cookbook 'egistics_storageproxy'
	variables({
			:url => node[:egistics][:fdc_web_service][:redirect_url]
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
	not_if { ::File.exists?("#{app_root}/web.config") || node[:egistics][:fdc_web_service][:baseapp] }
end

template "#{app_root}/web.config" do
  source "#{node[:egistics][:fdc_web_service][:web_config]}.erb"
	action :create
	variables({
		:ADV3499WACHLBX_archive_db => node[:ash_db_role] ? 'SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=AdvantaBank;Trusted_Connection=True' : 'SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=AdvantaBank;Trusted_Connection=True',
		:UBS0001LBX_archive_db => node[:ash_db_role] ? 'SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=UBS;Trusted_Connection=True' : 'SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=UBS;Trusted_Connection=True',
		:HONDAADC04285673_archive_db => node[:ash_db_role] ? 'SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Honda;Trusted_Connection=True' : 'SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Honda;Trusted_Connection=True',
		:InternalHelper_admin_db => node[:ash_db_role] ? 'SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_admin3g;Trusted_Connection=True' : 'SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_admin3g;Trusted_Connection=True',
		:InternalHelper_archive_db => node[:ash_db_role] ? 'SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_archive3g;Trusted_Connection=True' : 'SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_archive3g;Trusted_Connection=True',
		:test_ADV3499WACHLBX_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:test_UBS0001LBX_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:test_HONDAADC04285673_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:test_InternalHelper_admin_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:test_InternalHelper_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:test_DEMOLBX_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:DR_ADV3499WACHLBX_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:DR_UBS0001LBX_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:DR_HONDAADC04285673_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:DR_InternalHelper_admin_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:DR_InternalHelper_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:DR_DEMOLBX_archive_db => node[:ash_db_role] ? 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36' : 'SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36',
		:storage_proxy => node[:ash_db_role] ? 'https://ap-esl-spx-01.egistics.local/PRD-ESL-WSSPX-E1/synapticWebService.asmx' : 'https://dp-esl-spx-01.egistics.local/PRD-ESL-WSSPX-E1/synapticWebService.asmx'
		})
	notifies :restart, "iis_pool[#{config[:pool][:name]}]"
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

execute "config_#{node[:egistics][:fdc_web_service][:site_pool]}" do
	command "#{node[:iis][:home]}\\appcmd.exe set apppool \"#{node[:egistics][:fdc_web_service][:site_pool]}\" /autoStart:true /startMode:AlwaysRunning"
	action :nothing
end

execute "config_#{config[:pool][:name]}" do
	command "#{node[:iis][:home]}\\appcmd.exe set apppool \"#{config[:pool][:name]}\" /autoStart:true /startMode:AlwaysRunning"
	action :nothing
end

execute "config_#{site_name}#{app_name}" do
	command "#{node[:iis][:home]}\\appcmd.exe set app \"#{site_name}#{app_name}\" /preloadEnabled:true"
	action :nothing
end

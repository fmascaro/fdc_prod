env = nil
case node.chef_environment
when 'production'
  env = 'prd'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-01'
  efb = '\\\\DP-ESL-EFB-01'
  envcode = 'P'
when 'uat'
  env = 'uat'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-01'
  efb = '\\\\DP-ESL-EFB-01'
  envcode = 'U'
when 'development'
  env = 'dev'
  domain = 'EGDEV'
  efs = '\\\\PD-DEV-EFS-01'
  efb = '\\\\PD-DEV-EFS-01'
  envcode = 'D'
when 'qa'
  env = 'qa'
  domain = 'EGDEV'
  efs = '\\\\PD-DEV-EFS-01'
  efb = '\\\\PD-DEV-EFS-01'
  envcode = 'Q'
when 'staging'
  env = 'prd'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-01'
  efb = '\\\\DP-ESL-EFB-01'
  envcode = 'P'
when 'test'
  env = 'tst'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-01'
  efb = '\\\\DP-ESL-EFB-01'
  envcode = 'P'
when 'prodnext'
    env = 'PRDNEXT'
    domain = 'EGISTICS'
    efs = '\\\\DP-ESL-EFS-01'
    envcode = 'P'
  when 'config'
    env = 'cfg'
    domain = 'EGISTICS'
    efs = '\\\\DP-ESL-EFS-01'
    envcode = 'C'  
else
  env = 'prd'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-01'
  efb = '\\\\DP-ESL-EFB-01'
  envcode = 'P'
end

svc_db_item = data_bag_item('esl',"#{env}_fdc_services")

services = node.assigned_services

# StrongAuth block that will be the same no matter which node it is used on.  The EndpointUrl is substituded below if the node is in Ashburn.
strongauth = <<-EOH
								<StrongAuth.CryptoSection DomainIdentifier="1" EndpointUrl="https://dp-egi-cry-01:8181/strongkeyliteWAR/EncryptionService">
								<!--
								<Encrypt Algorithm="TripleDES" />
								<Encrypt Algorithm="TripleDES128" />
								<Encrypt Algorithm="AES192" Base64LineBreaks="false" />
								<Encrypt Algorithm="AES256" TargetDirectory="c:/somewhere/with/write/access"/>
								-->
								<Ping Password-Clear="Abcd1234!" />
								<Encrypt Algorithm="AES128" User="all" Password-Clear="f'j;ZdwmfBLYCOnio1Bo" KeyFlushMinutes="1440" TargetDirectory="L:\TIS\#{env}\ESL\WSSPX-E1" />
								<Decrypt User="all" Password-Clear="f'j;ZdwmfBLYCOnio1Bo" TargetDirectory="L:\TIS\#{env}\ESL\WSSPX-E1" />
								</StrongAuth.CryptoSection>
								EOH

services.each do |service|

	if service.downcase.include?('fdc')
		#Pull value for the application environment
		appenv = svc_db_item[service]['ServiceAccount'].split('-')[1]
		env = appenv

		# Add all of the directories to the list
		folders = Array.new

		['app_directory','LogPath','InputPaths','WorkFolderPaths','OutputPaths','BackupPaths','ExceptionPaths'].each do |node|
			if svc_db_item[service][node].is_a?(Array)
				folders += svc_db_item[service][node]
			else
				folders << svc_db_item[service][node]
			end
		end

		if node[:tags].include?("ashburn")
				folders.each do |s|
						s.gsub!(/[dD][pP]/, 'AP')
				end
				efs.gsub!(/[dD][pP]/, 'AP')
 				efb.gsub!(/[dD][pP]/, 'AP')
		end

		#create the folders on the file system
		folders.each do |dir|
			if dir.include?('WORKING') || dir.include?('EXCEPTION') || dir.include?('BACKUP') || dir.include?('SOCHOLD') || dir.include?('FTP') || dir.include?('STAGED') || dir.include?('3GFILEDELETION')
				directory dir do
					rights :full_control, "#{domain}\\#{svc_db_item[service]['ServiceAccount']}"
					rights :full_control, "#{domain}\\SOC 1"
					rights :full_control, "#{domain}\\SS 1"
					rights :full_control, "#{domain}\\Domain Admins"
					recursive true
					inherits true
				end unless dir.empty?
			else
				directory dir do
					rights :full_control, "#{domain}\\#{svc_db_item[service]['ServiceAccount']}"
					rights :full_control, "#{domain}\\Domain Admins"
					recursive true
				end unless dir.empty?
			end
		end

		check_file = "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['exename']}"

		windows_zipfile svc_db_item[service]['app_directory'] do
			source "#{svc_db_item[service]['artifact_path']}/#{svc_db_item[service]['artifact_filename']}"
			action :unzip
			not_if {::File.exists?(check_file)}
		end unless svc_db_item[service]['artifact_filename'].empty?

		#Substitute correct StrongAuth DNS name depending on node location
		if node[:tags].include?("ashburn")
					 strongauth.gsub!('dp-egi-cry-01', 'ap-esl-sau-lb')
			 end

		#Split Site from node name
		name = node.name
		site = name[0..1][0]

		template "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['config_filename']}" do
			source "#{svc_db_item[service]['ServiceName']}.erb"
			action :create
			variables({
				:efb => efb.upcase,
				:efs => efs.upcase,
				:storage_proxy => node[:tags].include?("ashburn") ? 'https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-E1/synapticWebService.asmx' : 'https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-E1/synapticWebService.asmx',
				:strongauthblock => strongauth,
				:site => site.upcase,
				:env => env.upcase,
				:envcode => envcode.upcase
				})
			notifies :restart, "service[#{svc_db_item[service]['ServiceName']}]"
		end unless svc_db_item[service]['config_filename'].empty?

		template "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['ConfigFilesExtra']}" do
			source "#{svc_db_item[service]['ServiceName']}_#{svc_db_item[service]['ConfigFilesExtra']}.erb"
			action :create
      variables({
        :env => env.upcase
      })
			notifies :restart, "service[#{svc_db_item[service]['ServiceName']}]"
		end unless svc_db_item[service]['ConfigFilesExtra'].empty?

		if svc_db_item[service]['TopShelf'] == true
			powershell_script "install_service" do
				code <<-EOH
					Function ServiceExists([string] $ServiceName) {
    					[bool] $Return = $False
    					if ( Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'" ) {
       					 $Return = $True
   			 			}
    					Return $Return
					}

					if ( -Not ( ServiceExists #{svc_db_item[service]['ServiceName']} ) ) {
						#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['exename']} install -servicename:#{svc_db_item[service]['ServiceName']} -displayname:#{svc_db_item[service]['ServiceName']} -description "#{svc_db_item[service]['ServiceDescription']}"
					}
				EOH
				action :run
			end

			topimagesystems_service svc_db_item[service]['ServiceName'] do
				run_as "#{domain}\\#{svc_db_item[service]['ServiceAccount']}"
				action :config
			end unless svc_db_item[service]['exename'].empty?

			service svc_db_item[service]['ServiceName'] do
				action :start
				ignore_failure true
			end

		else
			topimagesystems_service svc_db_item[service]['ServiceName'] do
				description svc_db_item[service]['ServiceDescription']
				path "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['exename']}"
				startup_type :demand
				run_as "#{domain}\\#{svc_db_item[service]['ServiceAccount']}"
				action :create
			end unless svc_db_item[service]['exename'].empty?

			service svc_db_item[service]['ServiceName'] do
				action :start
				ignore_failure true
			end
		end
	end

end

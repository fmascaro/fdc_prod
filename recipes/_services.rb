env = nil
case node.chef_environment
  when "production"
    env = "prd"
    domain = "EGISTICS"
  when "uat"
    env = "uat"
    domain = "EGISTICS"
  when "development"
    env = "dev"
    domain = "EGDEV"
  when "staging"
    env = "prd"
    domain = "EGISTICS"
  when "test"
    env = "tst"
    domain = "EGISTICS"
  else
    env = "prd"
    domain = "EGISTICS"
end
svc_db_item = data_bag_item('esl',"#{env}_fdc_services")

services = node.assigned_services

#StrongAuth block that will be the same no matter which node it is used on.  The EndpointUrl is substituded below if the node is in Ashburn.
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

		#Split Site and Environment from node name
		name = node.name
		site, environment = name[0..1][0], name[0..1][1]

		template "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['config_filename']}" do
			source "#{svc_db_item[service]['ServiceName']}.erb"
			action :create
			variables({
				:efb => node[:tags].include?("ashburn") ? '\\\\AP-ESL-EFB-01' : '\\\\DP-ESL-EFB-01',
				:efs => node[:tags].include?("ashburn") ? '\\\\AP-ESL-EFS-01' : '\\\\DP-ESL-EFS-01',
				:storage_proxy => node[:tags].include?("ashburn") ? 'https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-E1/synapticWebService.asmx' : 'https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-E1/synapticWebService.asmx',
				:strongauthblock => strongauth,
				:site => site
				:env => environment
				})
			notifies :restart, "service[#{svc_db_item[service]['ServiceName']}]"
		end unless svc_db_item[service]['config_filename'].empty?

		template "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['ConfigFilesExtra']}" do
			source "#{svc_db_item[service]['ServiceName']}_#{svc_db_item[service]['ConfigFilesExtra']}.erb"
			action :create
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
		batch 'Grant Service Control Permissions' do
			code <<-EOH
			    cd "C:/Program Files (x86)/Windows Resource Kits/Tools"
				SUBINACL.exe /service #{svc_db_item[service]['ServiceName']} /grant="SOC 1"=LQSTOP
				SUBINACL.exe /service #{svc_db_item[service]['ServiceName']} /grant="SS 1"=LQSTOP
				EOH
		end
	end

end

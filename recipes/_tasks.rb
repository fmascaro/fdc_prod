env = nil
case node.chef_environment
when 'production'
  env = 'prd'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-0'
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
else
  env = 'prd'
  domain = 'EGISTICS'
  efs = '\\\\DP-ESL-EFS-01'
  efb = '\\\\DP-ESL-EFB-01'
  envcode = 'P'
end

tsk_db_item = data_bag_item('esl',"#{env}_fdc_tasks")

tasks = node.assigned_tasks

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

tasks.each do |task|

	if task.downcase.include?('fdc')

		#Pull value for the application environment
		appenv = tsk_db_item[task]['ServiceAccount'].split('-')[1]
		env = appenv if (appenv.upcase == 'CFG')

		# Add all of the directories to the list
		folders = Array.new

		['app_directory','LogPath','InputPaths','WorkFolderPaths','OutputPaths','BackupPaths','ExceptionPaths'].each do |node|
			if tsk_db_item[task][node].is_a?(Array)
				folders += tsk_db_item[task][node]
			else
				folders << tsk_db_item[task][node]
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
					rights :full_control, "#{domain}\\#{tsk_db_item[task]['ServiceAccount']}"
					rights :full_control, "#{domain}\\SOC 1"
					rights :full_control, "#{domain}\\SS 1"
					rights :full_control, "#{domain}\\Domain Admins"
					recursive true
					inherits true
				end unless dir.empty?
			else
				directory dir do
					rights :full_control, "#{domain}\\#{tsk_db_item[task]['ServiceAccount']}"
					rights :full_control, "#{domain}\\Domain Admins"
					recursive true
				end unless dir.empty?
			end
		end

		check_file = "#{tsk_db_item[task]['app_directory']}/#{tsk_db_item[task]['exename']}"

		windows_zipfile tsk_db_item[task]['app_directory'] do
			source "#{tsk_db_item[task]['artifact_path']}/#{tsk_db_item[task]['artifact_filename']}"
			action :unzip
			not_if {::File.exists?(check_file)}
		end unless tsk_db_item[task]['artifact_filename'].empty?

		#Substitute correct StrongAuth DNS name depending on node location
		if node[:tags].include?("ashburn")
					 strongauth.gsub!('dp-egi-cry-01', 'ap-esl-sau-lb')
		end

		#Split Site from node name
	  name = node.name
		site = name[0..1][0]

		template "#{tsk_db_item[task]['app_directory']}/#{tsk_db_item[task]['config_filename']}" do
			source "#{tsk_db_item[task]['ServiceName']}.erb"
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
		end unless tsk_db_item[task]['config_filename'].empty?

		template "#{tsk_db_item[task]['app_directory']}/#{tsk_db_item[task]['ConfigFilesExtra']}" do
			source "#{tsk_db_item[task]['ServiceName']}_#{tsk_db_item[task]['ConfigFilesExtra']}.erb"
			action :create
		end unless tsk_db_item[task]['ConfigFilesExtra'].empty?


		powershell_script "CreateTheTask" do
			guard_interpreter :powershell_script
			code "
			if( '#{tsk_db_item[task]['frequency']}' -like 'daily' ){
				$trigger = New-ScheduledTaskTrigger -At #{tsk_db_item[task]['task_time']} -Daily
			}else{
				$duration = ([timeSpan]::maxvalue)
				$repeat = (New-Timespan -Minutes #{tsk_db_item[task]['frequency']})
				$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval $repeat -RepetitionDuration $duration
			}
			$action = New-ScheduledTaskAction #{tsk_db_item[task]['app_directory']}/#{tsk_db_item[task]['exename']}
			$principal = New-ScheduledTaskPrincipal -UserID #{domain}\\#{tsk_db_item[task]['ServiceAccount']} -LogonType Password
			Register-ScheduledTask #{tsk_db_item[task]['ServiceName']} -Action $action -Trigger $trigger -Principal $principal
			exit $LASTEXITCODE
			"
			not_if "(Get-ScheduledTask -TaskName '#{tsk_db_item[task]['ServiceName']}' | format-list -Property Taskname | Out-String) -match '#{tsk_db_item[task]['ServiceName']}'"
		end

	end

end

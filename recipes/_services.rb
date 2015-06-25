

svc_db_item = data_bag_item('web','fdc_services')

services = node.assigned_services

services.each do |service|

	[ svc_db_item[service]['app_directory'], svc_db_item[service]['LogPath'] ].each do |dir|	
		directory dir do
			recursive true
			inherits true
		end
	end

	check_file = "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['exename']}"

	windows_zipfile svc_db_item[service]['app_directory'] do
		source "#{svc_db_item[service]['artifact_path']}/#{svc_db_item[service]['artifact_filename']}"
		action :unzip
		not_if {::File.exists?(check_file)}
	end

	topimagesystems_service svc_db_item[service]['ServiceName'] do
		description svc_db_item[service]['ServiceDescription']
		path "#{svc_db_item[service]['app_directory']}/#{svc_db_item[service]['exename']}"
		startup_type :auto
		run_as "EGISTICS\\#{svc_db_item[service]['ServiceAccount']}"
		action :create
	end

	service svc_db_item[service]['ServiceName'] do
		action :start
	end

end
#!/bin/bash

PATH_tom=/home/kali/Downloads/apache-tomcat-8.5.82/bin
PATH_identityiq=/home/kali/Desktop/delete_script/target

#check no of tomcat instances
function check_no_of_tomcat_service()
{
	n_tomcat_instance=$(ps aux|pgrep java|wc -l)	
	echo $n_tomcat_instance
}


#run startup script
function run_startup_script()
{	
	
	eval ${PATH_tom}/startup.sh
}

#run shutdown script
function run_shutdown_script()
{
	eval ${PATH_tom}/shutdown.sh
	sleep 40	
}

#kill all process ids of tomcat
function kill_process_ids()
{
	kill_ids=$(ps aux|pgrep java|xargs kill -9)
	eval ${kill_ids}
	sleep 4
}

#check tomcat status after restart and retry if service is no up
 
function check_after_restart()
{
	
	flag=$(check_no_of_tomcat_service)
	n=1
	if [ $flag -eq $n ];
	then
	   exit
	else
	    run_startup_script
	      
	fi
	
}

function delete_identityiq_folder()
{
	if [ -d "$PATH_identityiq" ]; then
		printf '%s\n' "Removing Lock ($PATH_identityiq)"
		rm -rf "$PATH_identityiq"
	fi
}
#main
n_tomcat_running=$(check_no_of_tomcat_service)
n_tomcat_instance_normal=1

if [ $n_tomcat_running -lt $n_tomcat_instance_normal ]; 
then

	run_startup_script
	delete_identityiq_folder
	check_after_restart


elif [ $n_tomcat_running -eq $n_tomcat_instance_normal ]; 
then

	run_shutdown_script

	
	flag=$(check_no_of_tomcat_service)
	n=1
	if [ $flag -eq $n ];
	then
	
	  kill_process_ids
	fi
	delete_identityiq_folder
	run_startup_script
	check_after_restart
	
elif [ $n_tomcat_running -gt $n_tomcat_instance_normal ];
then
	kill_process_ids
	delete_identityiq_folder
	run_startup_script
	check_after_restart
	
fi

exit

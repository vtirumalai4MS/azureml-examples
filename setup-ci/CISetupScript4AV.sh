# This Script adds a cron job to run ClamAV's Clamscan every 12 hours
# The scan logs are stored in a path /home/azureuser/cloudfiles/code/Logs/$CI_NAME/Antimalware/
# The name of the log file would be clamav_scan.log
# This log can be manually viewed by IT Admin for any vulerabilites. 


log_dir=/home/azureuser/cloudfiles/code/Logs/$CI_NAME/Antimalware/
# make directory with the above path in compute instance
mkdir -p $log_dir
# add log path along with the log file name
log_path=${log_dir}clamav_scan.log
echo "ClamAV logging path is $log_path"

# this command runs the clamscan every 12 hours using the database file located in /var/lib/azsec-clamav
# this is saved in the form of a string so that it can be added as a cron job using cron tab

#crn_string="* */1 * * * sudo nice -n 19 clamscan -l ${log_path} -d /var/lib/azsec-clamav -r -i --exclude-dir=^/sys/ /bin /boot /home /lib /lib64 /opt /root /sbin"
# create file if it does not exist
# 30 0 * * *
sudo touch "$log_path"
sudo chmod 777 "$log_path"
# do not provide the data file path
crn_string="* */12 * * * sudo nice -n 19 clamscan -l $log_path -r -i --exclude-dir=^/sys/ /bin /boot /home /lib /lib64 /opt /root /sbin"

echo "The command that is being added to the cron job: $crn_string"
# this command is used to add to the existing cronjobs for the root using crontab
(sudo crontab -l 2>/dev/null; echo "$crn_string") | sudo crontab -

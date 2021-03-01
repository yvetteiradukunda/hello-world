#/!bin/bash
#variables
ACTION=${1}
version="1.0.0"
awsusername="yvetteiradukunda"

function update_system_packages() {
sudo yum update -y
}
function install_nginx_software_package() {
sudo amazon-linux-extras install nginx1.12 -y
}

function copy_s3_files()  {
sudo aws s3 cp s3://$awsusername-assignment-webserver/index.html /usr/share/nginx/html
}

function auto_turn_on_nginx() {
sudo chkconfig nginx on
}
function Start_nginx_service() {
sudo service nginx start
}
function stop_nginx_service() {
sudo service nginx stop
}

function delete_files() {
cd /usr/share/nginx/html
sudo rm index.html
}

function uninstall_nginx() {
yum remove nginx -y
}

function show_version() {
echo "$version"
}

function display_help() {
cat << EOF
Usage: ${0} { $1|-r|--remove|-h|--help|-v|--version}
OPTIONS:
$1  Initialize nginx
-r| --remove Deprovision nginx
-h | --help Display the command help
-v | --version Display the script version
Examples:
install, start Nginx and copy website documents from s3:
$ ${0} 
stop, uninstall Nginx and delete all files in the website document root directory:
$ ${0} -r 
Display help:
$ ${0} -h
Display script version:
$ ${0} -v
EOF
}

case "$ACTION" in
-h|--help)
display_help
;;
-r|--remove)
stop_nginx_service
delete_files
uninstall_nginx
;;
"")
update_system_packages
install_nginx_software_package
auto_turn_on_nginx
copy_s3_files
Start_nginx_service
;;
-v|--version)
show_version
;;
*)
echo "Usage ${0} {|-r|-h|-v}"
exit 1
esac

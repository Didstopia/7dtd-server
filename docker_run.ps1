#you need to allow docker access to the shared drive the git repo is on, this is done through the GUI

#run build first
.\docker_build.ps1

#get pwd.. because Get-Location doesn't work
$pwd = (Get-Location).tostring().Replace('\','/')

#start command
docker run --rm -it -p 26900:26900/tcp -p 26900:26900/udp -p 26901:26901/udp -p 26902:26902/udp -p 3000:3000/tcp -p 8080:8080/tcp -p 8081:8081/tcp -e SEVEN_DAYS_TO_DIE_UPDATE_CHECKING="1" -e SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS="-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated" -e SEVEN_DAYS_TO_DIE_UPDATE_BRANCH="latest-experimental" -v ${pwd}/7dtd_data:/steamcmd/7dtd didstopia/7dtd-server:latest
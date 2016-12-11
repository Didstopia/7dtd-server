## 7 Days to Die server that runs inside a Docker container

NOTE: This image will always install/update to the latest steamcmd and 7 Days to Die server, all you have to do to update your server is to redeploy the container.

Also note that the entire /steamcmd/7dtd can be mounted on the host system.

# How to run the server
1. Set the ```SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS``` environment variable to match your preferred server arguments (defaults are set to ```"-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated"```, note how we're logging to stdout)
2. Optionally mount ```/steamcmd/7dtd``` somewhere on the host or inside another container to keep your data safe
3. Run the container and enjoy!

You can control the startup mode by using ```SEVEN_DAYS_TO_DIE_START_MODE```. This determines if the server should update and then start (mode 0), only update (mode 1) or only start (mode 2)) The default value is ```"0"```.

Note that you should also enable telnet and optionally modify the ```SEVEN_DAYS_TO_DIE_TELNET_PORT``` and ```SEVEN_DAYS_TO_DIE_TELNET_PASSWORD``` environment variables accordingly, so the container can properly send the shutdown command to the server when the proper signal has been received (it uses telnet for this).

One additional feature you can enable is fully automatic updates, meaning that once a server update hits Steam, it'll restart the server and trigger the automatic update. You can enable this by setting ```SEVEN_DAYS_TO_DIE_UPDATE_CHECKING``` to ```"1"```.
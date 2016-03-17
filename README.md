## 7 Days to Die server that runs inside a Docker container

NOTE: This image has been updated so that it installs/updates 7 Days to Die on startup!

Since this image will always install/update to the latest steamcmd and 7 Days to Die server, all you have to do to update your server is to redeploy the container.
Also note that the entire /steamcmd can be mounted on the host system.

# How to run the server
1. Set the ```SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS``` environment variable to match your preferred server arguments (defaults are set to ```"-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated"```, note how we're logging to stdout)
2. Optionally mount ```/steamcmd``` somewhere on the host or inside another container to keep your data safe
3. Run the container and enjoy!

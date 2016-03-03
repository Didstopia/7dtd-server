## 7 Days to Die server that runs inside a Docker container

Updated to [Alpha 13.8](https://7daystodie.com/alpha-13-8-is-out/)

# How to run the server
1. Set the ```SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS``` environment variable to match your preferred server arguments (defaults are set to ```"-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated"```, note how we're logging to stdout)
2. Optionally mount ```/steamcmd/7dtd/server_data``` somewhere on the host or inside another container to keep your data safe
3. Run the container and enjoy!

**NOTE:** The ```/steamcmd/7dtd/server_data``` folder needs to have a valid ```serverconfig.xml``` file, otherwise the server won't start. This is a bug that we're still trying to figure out on our end, since 7DTD doesn't seem to create the file on it's own.

## 7 Days to Die server that runs inside a Docker container

# How to run the server
1. Set the ```7DTD_SERVER_STARTUP_ARGUMENTS``` environment variable to match your preferred server arguments (defaults are set to ```"-configfile=server_data/serverconfig.xml -logfile server_data/7dtd.log"```)
2. Optionally mount ```/7dtd_data``` somewhere on the host or inside another container to keep your data safe
3. Run the container and enjoy!

**NOTE:** The ```/7dtd_date``` needs to have a valid ```serverconfig.xml```, otherwise the server won't start. This is a bug that we're still trying to figure out on our end, since 7DTD doesn't seem to create the file on it's own.
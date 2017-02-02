# alpine-minecraftsvr

Thanks to the Alpine-Java image out on Dockerhub: [https://hub.docker.com/r/thetallgrassnet/alpine-java/ thetallgrassnet/alpine-java]

I have been able to produce a Minecraft Docker image that spawns a new world upon startup or loads a world that you provide (FUTURE - In progress - to include any json-provided configuration, etc.)  How does this work with Docker?

Docker Image of Minecraft, names  - labelled for version expression
* For example, initial image is Minecraft Server 1.11.2
* Image contains no world or player data
* Image is 146 MB in size - OS and All thanks to Busybox / Alpine!
* Image deploys in seconds



# Target Hosting Deployment
DigitalOcean / Docker App on CoreOS:

# World Deployment
Docker-minecraft deploys without a pre-built world, allowing developers to specify their own world and tell the docker container at startup where to mount in the desired world and configurations.  The trouble in the target deployment environement is that we cannot readily SSH or SCP to the host.  We have to consider a different way to get the world data accessible by our Docker container running at DigitalOcean.

Here are some concerns...
1. Docker container needs to mount Data Volume to store world and player data such that is survives crashes, restarts and upgrades
2.  Docker Data Volume may need pre-loading as world construction takes place in creative mode on the developer's desktop Minecraft.  How do I get the new world out to the server?  
..* With Docker 1-click App usage, there are no SSH accounts.  There is no obvious way to maintain the server...

DON'T  SSH into the box!  DON'T turn it into a pet!  What do we do?



# Maintenance
## Container Maintenance
1. Minecraft Docker Image is the server.  Upgrades to the server result in a new Docker Image with any updates (Java, Alpine or Minecraft) included with Labels addressing the mods.  
2. Configs are updated and pushed to Github
3. Image is built and pushed to DockerHub.
4. User stops the current instance of docker-minecraft server and docker runs the new image.  If things work, user is happy.  If they don't, user restarts previous docker container and is happy.

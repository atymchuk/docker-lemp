# Docker: Ubuntu, Nginx, MySQL and PHP Stack

This is the basis for LEMP stack. This is based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) base Ubuntu image, which takes care of system issues which Docker's base Ubuntu image does not take care of, such as watching processes, logrotate, ssh server, cron and syslog-ng.

You can build this yourself after cloning the project (assuming you have Docker installed).

```bash
cd /path/to/repo/docker-lemp
docker build -t webapp . # Build a Docker image named "webapp" from this location "."
# wait for it to build...

# Run the docker container
docker run -v /path/to/local/web/files:/var/www:rw -p 80:80 -p 3306:3306 -d webapp /sbin/my_init --enable-insecure-key
```

This will bind local ports 80 and 3306 to the respective container's ports. This means you should be able to go to "localhost" in your browser (or the IP address of your virtual machine oh which Docker is running) and see your web application files.

* `docker run` - starts a new docker container
* `-v /path/to/local/web/files:/var/www:rw` - Bind a local directory to a directory in the container for file sharing. `rw` makes it "read-write", so the container can write to the directory.
* `-p 80:80` - Binds the local port 80 to the container's port 80, so local web requests are handled by the docker.
* `-p 3306:3306` - Binds the local port 3306 to the container's port 3306, so local web requests are handled by the docker.
* `-d webapp` - Use the image tagged "webapp"
* `/sbin/my_init` - Run the init scripts used to kick off long-running processes and other bootstrapping, as per [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker)
* `--enable-insecure-key` - Enable a generated SSL key so you can SSH into the container, again as per [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker). Generate your own SSH key for production use.

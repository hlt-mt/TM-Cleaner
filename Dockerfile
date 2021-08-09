FROM  python:3.6.9

# Create app directory
WORKDIR /server

# Install dependencies
RUN pip3 install laserembeddings
RUN python -m laserembeddings download-models

# Copy needed files
COPY CMD.httpserver_start.sh httpserver.py /server/
RUN mkdir -p /server/WWW
COPY WWW/. /server/WWW/

# define the port number the container should expose
EXPOSE 8081

# run the command
CMD ["bash", "CMD.httpserver_start.sh"]


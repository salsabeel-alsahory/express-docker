# The base image that will have node dep
FROM node:18.16.1-alpine

# Set the current working directory in the container
WORKDIR /usr/app

Run apk add curl
RUN apt-get -y update
RUN apt-get -y install nginx
# Copy only two files to the image
COPY package.json package-lock.json ./

# Execute a command while building the container
RUN npm ci

# Now copy the project files
ADD . . 
# Build the app
RUN npm run build

HEALTHCHECK --interval=5m --timeout=3s \
CMD curl -f http:/localhost/ || exit 1

# When running the container, execute the following command
CMD node ./dist/main.js
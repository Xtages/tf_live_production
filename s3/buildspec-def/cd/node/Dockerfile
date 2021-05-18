FROM 606626603369.dkr.ecr.us-east-1.amazonaws.com/xtages-build-images/node_cd:0.1.0

RUN adduser -D nodejsapp
WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install
COPY . .
EXPOSE 3000
CMD node src/server.js
USER nodejsapp

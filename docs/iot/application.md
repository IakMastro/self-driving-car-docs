---
sidebar_position: 2
---

# Application Based

The the tech stack for the application side of the Self Driving Car project was MEVN (Mongo, Express, Vue and NodeJS) with Redis for memory based database and deployed on a Docker Swarm environment.

## Stack

The MEVN stack is a combination of technologies working together used to build premium web applications. It is a JavaScript stack that's designed to make the development process as smooth as possible.

The acronym for MEVN means MongoDB, Express, Vue and Nodejs. In the stack, Redis is also added for a memory-based database on each car.

Each of the components on the stack has a corresponding node on the Swarm. The Swarm is designed with one master machine and two workers, whom will be the cars.

> [More info on an alternative stack for ReactJS](https://www.softprodigysolutions.com/mern-stack-the-most-preferred-technology-stack-for-web-development/)

### MongoDB

MongoDB is a really fast and reliable NoSQL, document-based database. This type of databases have a lot of differences with SQL databases.

In SQL databases, a table has columns to define a table which holds the data. The equivalent of the table in a MongoDB is a collection and instead of columns, it has fields and values on a JSON format.

#### Document template

```json
{
  "_id": "x74xi6tq2w8531",
  "name": "John",
  "surname": "Doe"
}
```

> MongoDB can also run replicated on multiple nodes in the swarm. [More info here!](https://docs.mongodb.com/manual/replication/)

### Redis

Redis is a in-memory data structure store, used asa database cache and message broker.

> [More info here!](https://redis.io/)

### Express

Express is a fast, unopinionated, minimalist web framework for NodeJS. In this project it is used to build the middleware and the REST API for the application.

#### Install Express

```bash
$ npm install express --save
```

#### Basic configuration

```js
const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World')
})

app.get(port, () => {
  console.log(`Example app running at http://localhost:${port}`)
})
```

> [More info for Express here!](https://expressjs.com/)

### VueJS

VueJS is a front-end framework for NodeJS, alternative to Angular and React. [Check how a VueJS project is made here!](https://v3.vuejs.org/guide/introduction.html#what-is-vue-js). In this project, the role of this node is really minimal and simple. It only showcases data from the database.

## Swarm

The Swarm used for this project is implemented with Docker Swarm Engine and it uses containers made with Docker.

### Docker

Docker creates virtualized environments called containers. It makes the development and the deployment much easier and it's very efficient and flexible to what it can do.

> [More info for Docker here!](https://www.docker.com/)

Docker can build and deploy images, either made from existing images from the hub or a custom one from a Dockerfile.

#### Custom image

This is a template for a custom nodejs environment that runs a server!

```Dockerfile
FROM node:17-alpine3.13 # Image from the Docker hub

WORKDIR /api # The directory inside in the container

COPY package*.json /api/ # Copying from the host system to the container

RUN npm i # Running commands inside the container for init

COPY . . # Copy everything from the host system to the container

CMD ["npm", "run", "serve"] # Run the final command of the container
```

### Docker Compose

``docker-compose`` is a docker tool that allows continuous integration/continuous development (CI/CD) really easily.

It is written in yaml and it is used in this project to make the development of each node really easily.

#### docker-compose.yml example

```yaml
version: '3.9' # docker-compose version, each version is different from the other

services: # Define the services here
  client: # Service name
    build: app # Local directory in the system which stores a Dockerfile
    container_name: car-interface # Name of the container
    hostname: interface # URL that has inside the Swarm
    ports: # Port forward the ports to the local system
      - 8080:8080
    volumes: # Local directories that are mounted inside the container
      - ./app:/app # Name of the local directory
    environment: # System environments of the system
      NODE_APP: self-driving-car-interface
      NODE_ENV: development
    depends_on: # It waits for this to start
      - rest
    networks: # Docker networks it belongs
      - datacenternet
    logging: # Logging engine
      driver: "fluentd" # Name of the logging device
      options:
        fluentd-address: localhost:24224
        tag: log.interface

  mongo: # Second service
    image: mongo # Image that exists on Docker hub
    networks:
      - datacenternet

networks: # Define the networks here
  datacenternet: # Network name
    name: datacenternet
```

### Docker Swarm

TODO: Add a description of how it works, alongside with how Redis is used on the project.

### FluentD

FluentD is a logging engine used to log the nodes that are on keen interest to know that everything is going as they are supposed to be going.

In this project, it stores the log on the local container and on a mongodb database. It needs a configuration file for it to work.

> [More on how it works here, from a similar project made for Cloud Computing!](https://github.com/IakMastro/Cloud-Eshop-Project-2021)
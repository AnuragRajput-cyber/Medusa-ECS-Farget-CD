FROM node:18-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache python3 py3-pip make g++ postgresql-client

# Install Medusa CLI globally
RUN npm install -g @medusajs/medusa-cli

# Create a new Medusa project
RUN medusa new medusa-store --seed

WORKDIR /app/medusa-store

# Install dependencies
RUN npm install

# Change from:
COPY entrypoint.sh .

# To this (explicit path):
COPY ./entrypoint.sh .

# Make script executable
RUN chmod +x entrypoint.sh

# Expose Medusa port
EXPOSE 9000

# Start Medusa
ENTRYPOINT ["./entrypoint.sh"]
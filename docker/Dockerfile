FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache python3 py3-pip make g++ postgresql-client

# Install Medusa CLI
RUN npm install -g @medusajs/medusa-cli

# Create and set working directory
WORKDIR /app

# Create Medusa project
RUN medusa new medusa-store --seed && \
    cd medusa-store && \
    npm install

# Copy entrypoint
COPY docker/entrypoint.sh /app/medusa-store/

# Set final working directory
WORKDIR /app/medusa-store

# Make script executable
RUN chmod +x entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["./entrypoint.sh"]
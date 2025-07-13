FROM node:18-alpine

# 1. Install system dependencies
RUN apk add --no-cache python3 py3-pip make g++ postgresql-client

# 2. Install Medusa CLI globally
RUN npm install -g @medusajs/medusa-cli

# 3. Create app directory structure
WORKDIR /app
RUN mkdir -p medusa-store
WORKDIR /app/medusa-store

# 4. Create Medusa project (with explicit path)
RUN medusa new . --seed --no-install

# 5. Install dependencies
RUN npm install

# 6. Copy entrypoint script
COPY docker/entrypoint.sh .

# 7. Make script executable
RUN chmod +x entrypoint.sh

# 8. Expose and configure runtime
EXPOSE 9000
ENTRYPOINT ["./entrypoint.sh"]
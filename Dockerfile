# Step 1: Build the Angular application using Node.js container
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /angular-app

# Copy package.json and package-lock.json (or yarn.lock) for npm install
COPY package*.json ./

# Install the app dependencies
RUN npm install

# Copy the entire application source code into the container
COPY . .

# Build the Angular SSR app (both browser and server-side bundles)
RUN npm run build

# Step 2: Create the production image
# Use a Node.js image to serve the SSR app
FROM node:18-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built app from the previous build stage
COPY --from=build /angular-app/dist /app/dist

# Install only production dependencies
COPY package*.json ./
RUN npm install --production

# Expose the default port for Node.js (SSR app)
EXPOSE 4000

# Start the Angular SSR app (node server-side rendering)
CMD ["node", "dist/docker-app/server/server.mjs"]

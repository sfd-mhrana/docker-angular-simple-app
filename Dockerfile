# Step 1: Build the Angular Universal app

# Use a Node.js image for the build stage
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies (including Angular Universal and Express)
RUN npm install

# Copy the entire application into the container
COPY . .

# Build the browser and server versions of the Angular Universal app
RUN npm run build

# Step 2: Run the Angular Universal SSR server using Express

# Use a smaller Node.js image for the runtime stage
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/dist /app/dist
COPY --from=build /app/package*.json /app/

# Install production dependencies
RUN npm install --production

# Expose port 4000 for the SSR server
EXPOSE 4000

# Run the SSR Express server with Node.js
CMD ["node", "dist/server/server"]

## Stage 1: build
FROM node:18-alpine AS build

ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

WORKDIR /app

# install dependencies
COPY package*.json ./
RUN npm install

# copy project
COPY . .

# build vite project
RUN npm run build

## Stage 2: serve with nginx
FROM nginx:1.25-alpine

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
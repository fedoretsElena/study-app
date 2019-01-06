FROM node:10-alpine as build-stage
WORKDIR /app
COPY ./package*.json /app/
RUN npm install
COPY ./ /app/
RUN npm run build:multi-lang

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.15.5-alpine
COPY --from=build-stage /app/dist/study-app-en /usr/share/nginx/html/en/
COPY --from=build-stage /app/dist/study-app-uk /usr/share/nginx/html/uk/

# Copy the default nginx.conf provided by tiangolo/node-frontend
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

FROM nginx:latest

# Remove the default site config if you want to fully replace it
RUN rm /etc/nginx/conf.d/default.conf

# Copy website content
COPY content/ /usr/share/nginx/html/

# Copy custom nginx configuration files
COPY conf/ /etc/nginx/
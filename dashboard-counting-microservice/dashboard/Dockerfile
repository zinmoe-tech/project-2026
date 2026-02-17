FROM debian:bullseye-slim
WORKDIR /app

# Copy the binary and assets
COPY dashboard-service /app/dashboard-service
COPY assets /app/assets

# Make binary executable
RUN chmod +x /app/dashboard-service

# Expose the port
EXPOSE 9002

# Set environment variables
ENV PORT=9002
ENV COUNTING_SERVICE_URL=http://counting.microservices.local:9001

# Run the service
CMD ["/app/dashboard-service"]

FROM debian:bullseye-slim
WORKDIR /app

# Copy the binary
COPY counting-service /app/counting-service

# Make binary executable
RUN chmod +x /app/counting-service

# Expose the port
EXPOSE 9001

# Set environment variables
ENV PORT=9001

# Run the service
CMD ["/app/counting-service"]

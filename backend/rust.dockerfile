# Build stage
FROM rust:1.69-buster as builder

WORKDIR /app

# Set build arguments and environment variables
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# Copy source code
COPY . .

# Add Cargo configuration
RUN mkdir -p .cargo
RUN echo '[net]\ngit-fetch-with-cli = true' > .cargo/config

# Update SSL certificates
RUN apt-get update && apt-get install -y ca-certificates

# Build the application
RUN cargo build --release

# Production stage
FROM debian:buster-slim

WORKDIR /user/local/bin

# Copy the built application from the builder stage
COPY --from=builder /app/target/release/backend .

# Set the entrypoint
CMD ["./backend"]

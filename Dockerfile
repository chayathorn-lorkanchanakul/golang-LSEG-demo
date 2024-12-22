# Start from the latest golang base image
FROM golang:latest as builder

# Add Maintainer Info
LABEL maintainer="Chayathorn Lorkanchanakul <chayathorn.lorkanchanakul@outlook.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY ./app/* ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod init example.com/main

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o main .

FROM scratch

WORKDIR /app

COPY --from=builder /app/main /app/

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["/app/main"]
# Use a slim Python image
FROM python:3.11-slim

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY . .

# Install the project and its dependencies
# We use --system to install into the system Python environment in the container.
# The [firestore] extra enables GOOGLE_ADS_MCP_STORAGE_TYPE=firestore so OAuth
# state survives Cloud Run instance restarts. FastMCP is pinned below 4.x
# because upstream is tested against 3.x only.
RUN uv pip install --system ".[firestore]" "fastmcp>=3.2.0,<4"

# Expose port 8080 (default for Cloud Run)
EXPOSE 8080

# Define the command to run the server
# This uses the entry point defined in pyproject.toml
CMD ["google-ads-mcp"]

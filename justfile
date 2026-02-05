# SPDX-License-Identifier: PMPL-1.0-or-later
# SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

# List available recipes
default:
    @just --list

# Install dependencies
deps:
    mix deps.get

# Compile the project
build:
    mix compile

# Run tests
test:
    mix test

# Run tests with coverage
test-coverage:
    mix coveralls.html

# Format code
fmt:
    mix format

# Check code formatting
fmt-check:
    mix format --check-formatted

# Run linter
lint:
    mix credo --strict

# Run type checker
dialyzer:
    mix dialyzer

# Run all quality checks
quality: fmt-check lint dialyzer

# Generate documentation
docs:
    mix docs

# Clean build artifacts
clean:
    mix clean
    rm -rf _build deps doc

# Start the LSP server (stdio mode)
start:
    mix run --no-halt

# Start IEx REPL with project loaded
repl:
    iex -S mix

# Run a specific adapter test
test-adapter adapter:
    mix test test/adapters/{{adapter}}_test.exs

# Check for outdated dependencies
deps-outdated:
    mix hex.outdated

# Update dependencies
deps-update:
    mix deps.update --all

# Create a release build
release:
    MIX_ENV=prod mix release

# Run CI checks locally
ci: quality test

# Setup project from scratch
setup: deps build test
    @echo "✓ Project setup complete"

# Test Redis Streams adapter (requires redis-cli)
test-redis:
    @echo "Testing Redis Streams adapter..."
    @redis-cli --version || echo "Warning: redis-cli not installed"
    mix test test/adapters/redis_streams_test.exs

# Test RabbitMQ adapter (requires rabbitmqctl)
test-rabbitmq:
    @echo "Testing RabbitMQ adapter..."
    @rabbitmqctl version || echo "Warning: rabbitmqctl not installed"
    mix test test/adapters/rabbitmq_test.exs

# Test NATS adapter (requires nats CLI)
test-nats:
    @echo "Testing NATS adapter..."
    @nats --version || echo "Warning: nats CLI not installed"
    mix test test/adapters/nats_test.exs

# Check which queue CLI tools are installed
check-tools:
    @echo "Checking message queue CLI tools..."
    @echo -n "redis-cli: " && (redis-cli --version 2>/dev/null || echo "NOT INSTALLED")
    @echo -n "rabbitmqctl: " && (rabbitmqctl version 2>/dev/null || echo "NOT INSTALLED")
    @echo -n "nats: " && (nats --version 2>/dev/null || echo "NOT INSTALLED")

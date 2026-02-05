# poly-queue-lsp Project Summary

**Created:** 2026-02-05
**Status:** Initial implementation complete, ready for LSP server development

## Overview

poly-queue-lsp is a Language Server Protocol implementation for message queue management, providing IDE integration for Redis Streams, RabbitMQ, and NATS. Built with Elixir's BEAM VM for fault tolerance and concurrent operations.

## Project Structure

```
poly-queue-lsp/
├── lib/
│   ├── adapters/
│   │   ├── behaviour.ex          # Adapter behaviour with 8 callbacks
│   │   ├── redis_streams.ex      # Redis Streams adapter (redis-cli)
│   │   ├── rabbitmq.ex           # RabbitMQ adapter (rabbitmqctl/rabbitmqadmin)
│   │   └── nats.ex               # NATS adapter with JetStream (nats CLI)
│   ├── poly_queue_lsp/
│   │   └── application.ex        # OTP application with supervision
│   └── poly_queue_lsp.ex         # Main module
├── test/
│   ├── adapters/
│   │   └── redis_streams_test.exs
│   └── test_helper.exs
├── vscode-extension/
│   ├── src/
│   │   └── extension.ts          # VSCode extension with queue commands
│   ├── package.json
│   └── tsconfig.json
├── STATE.scm                     # Project state checkpoint
├── META.scm                      # Architecture decisions
├── ECOSYSTEM.scm                 # Ecosystem position
├── README.adoc                   # Comprehensive documentation
├── CHANGELOG.md
├── justfile                      # Build recipes
├── mix.exs                       # Elixir project config
└── LICENSE                       # PMPL-1.0-or-later
```

## Implemented Components

### 1. Adapter Behaviour (lib/adapters/behaviour.ex)

Defines 8 callbacks for consistent queue operations:

- `detect/0` - Detect if queue system is available
- `publish/3` - Publish message to queue
- `subscribe/2` - Subscribe to queue and receive messages
- `list_queues/0` - List all available queues
- `queue_status/1` - Get queue statistics
- `purge_queue/1` - Empty a queue
- `version/0` - Get queue system version
- `metadata/0` - Get system metadata

### 2. Redis Streams Adapter (lib/adapters/redis_streams.ex)

**CLI Tool:** redis-cli
**Features:**
- XADD for publishing
- XREADGROUP for consuming with consumer groups
- XLEN for queue length
- XINFO GROUPS for consumer group info
- Stream management (create, delete, purge)

**Key Functions:**
- Consumer group support
- Message replay
- Persistence
- Pattern-based subscriptions

### 3. RabbitMQ Adapter (lib/adapters/rabbitmq.ex)

**CLI Tools:** rabbitmqctl, rabbitmqadmin
**Protocol:** AMQP 0-9-1
**Features:**
- Queue declaration and management
- Message publishing with routing keys
- Consumer acknowledgments
- Priority queues
- Exchange routing

**Key Functions:**
- Durable queues
- Message TTL
- Dead letter queues
- Consumer groups via exchanges

### 4. NATS Adapter (lib/adapters/nats.ex)

**CLI Tool:** nats
**Protocol:** NATS Protocol
**Features:**
- Core NATS pub/sub
- JetStream persistence
- Stream management
- Consumer groups (durable, ephemeral)
- At-least-once delivery

**Key Functions:**
- Lightweight pub/sub
- JetStream for persistence
- Replay capability
- Subject-based routing

### 5. OTP Application (lib/poly_queue_lsp/application.ex)

Supervision tree with:
- One supervisor for all adapters
- One-for-one restart strategy
- Isolated adapter processes
- Automatic fault recovery

### 6. VSCode Extension (vscode-extension/)

TypeScript extension with commands:
- `polyqueue.listQueues` - List all queues
- `polyqueue.queueStatus` - Show queue statistics
- `polyqueue.publish` - Publish message
- `polyqueue.subscribe` - Subscribe to queue
- `polyqueue.purgeQueue` - Purge queue (with confirmation)

Configuration for Redis, RabbitMQ, and NATS connection settings.

## Checkpoint Files

### STATE.scm
- 80% completion
- Tracks milestones: adapters (100%), docs (100%), LSP server (0%), tests (0%)
- Critical next actions: LSP server implementation, test suite, CI/CD

### META.scm
- ADR-001: Use CLI tools instead of native libraries
- ADR-002: Isolated GenServer per adapter
- ADR-003: Common adapter behaviour
- Design rationale for Elixir/OTP and multi-queue support

### ECOSYSTEM.scm
- Positioned as developer tooling for message queues
- Related to poly-ssg-lsp (template source)
- Dependencies: Elixir, gen_lsp, jason, redix
- External tools: redis-cli, rabbitmqctl, rabbitmqadmin, nats

## Usage Examples

### Redis Streams
```elixir
# Publish
PolyQueue.Adapters.RedisStreams.publish("orders", %{order_id: 123, amount: 50.00})

# Subscribe with consumer group
PolyQueue.Adapters.RedisStreams.subscribe("orders",
  consumer_group: "processors",
  count: 10)

# Get status
PolyQueue.Adapters.RedisStreams.queue_status("orders")
```

### RabbitMQ
```elixir
# Publish with priority
PolyQueue.Adapters.RabbitMQ.publish("tasks", "Process this", priority: :high)

# Subscribe
PolyQueue.Adapters.RabbitMQ.subscribe("tasks", count: 5)

# Purge queue
PolyQueue.Adapters.RabbitMQ.purge_queue("tasks")
```

### NATS JetStream
```elixir
# Publish to stream
PolyQueue.Adapters.NATS.publish("events",
  %{event: "user.login", user_id: 456},
  stream: true)

# Subscribe with durable consumer
PolyQueue.Adapters.NATS.subscribe("events",
  stream: true,
  durable: true,
  consumer: "event-processor")
```

## Key Design Decisions

1. **CLI-First Approach**: Uses CLI tools (redis-cli, rabbitmqctl, nats) instead of native Elixir libraries for better compatibility and simpler deployment.

2. **Fault Isolation**: Each adapter runs as a supervised GenServer. Crashes in one adapter don't affect others.

3. **Unified API**: Common behaviour across all adapters provides consistent LSP experience regardless of queue system.

4. **BEAM VM Advantages**: Leverages Erlang VM's built-in fault tolerance and lightweight processes.

## Next Steps

### High Priority
1. **LSP Server Implementation**
   - Create `lib/lsp/server.ex`
   - Implement completion handler
   - Implement diagnostics handler
   - Implement hover handler

2. **Test Suite**
   - Add tests for RabbitMQ adapter
   - Add tests for NATS adapter
   - Add integration tests
   - Add LSP handler tests

3. **CI/CD**
   - Add GitHub Actions workflows
   - Add CodeQL analysis
   - Add test coverage reporting

### Medium Priority
1. **VSCode Extension Enhancement**
   - Add queue visualization
   - Add message inspection
   - Add consumer group monitoring
   - Add real-time queue statistics

2. **Documentation**
   - Add API reference
   - Add tutorial/quickstart
   - Add troubleshooting guide
   - Add adapter development guide

3. **Additional Features**
   - Message schema validation
   - Dead letter queue handling
   - Message tracing
   - Performance profiling

## Dependencies

### Runtime
- Elixir ~> 1.17
- gen_lsp ~> 0.10
- jason ~> 1.4
- redix ~> 1.5

### Development
- credo ~> 1.7
- dialyxir ~> 1.4
- ex_doc ~> 0.34
- excoveralls ~> 0.18
- mox ~> 1.1

### External CLI Tools
- redis-cli (Redis Streams)
- rabbitmqctl (RabbitMQ management)
- rabbitmqadmin (RabbitMQ admin)
- nats (NATS and JetStream)

## Justfile Recipes

Common commands:
- `just setup` - Install deps, compile, test
- `just test` - Run all tests
- `just quality` - Format check, lint, dialyzer
- `just test-redis` - Test Redis adapter
- `just test-rabbitmq` - Test RabbitMQ adapter
- `just test-nats` - Test NATS adapter
- `just check-tools` - Check which CLI tools are installed
- `just start` - Start LSP server

## Git Status

Repository initialized with initial commit:
- Commit: ab6ed05
- Branch: main
- 21 files committed
- 2106 lines added

## License

PMPL-1.0-or-later (Palimpsest License)

## Author

Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

## Related Projects

- **poly-ssg-lsp**: Template source, LSP patterns
- **poly-ssg-mcp**: Sibling MCP server project
- Part of the hyperpolymath ecosystem

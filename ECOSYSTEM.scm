;; SPDX-License-Identifier: PMPL-1.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

(ecosystem
  (version "1.0")
  (name "poly-queue-lsp")
  (type "Language Server")
  (purpose "IDE integration for message queue management")

  (position-in-ecosystem
    (role "Developer Tooling")
    (layer "IDE Integration")
    (scope "Message queue operations across Redis Streams, RabbitMQ, NATS")
    (audience "Developers working with message queues"))

  (related-projects
    (project
      (name "poly-ssg-lsp")
      (url "https://github.com/hyperpolymath/poly-ssg-lsp")
      (relationship "sibling-standard")
      (description "Template and pattern source")
      (integration "Shares LSP architecture and OTP supervision patterns"))

    (project
      (name "poly-ssg-mcp")
      (url "https://github.com/hyperpolymath/poly-ssg-mcp")
      (relationship "sibling-standard")
      (description "Model Context Protocol server for SSGs")
      (integration "Complementary protocol implementation"))

    (project
      (name "redis")
      (url "https://redis.io/")
      (relationship "dependency")
      (description "Redis CLI tool for Redis Streams")
      (integration "Uses redis-cli for stream operations"))

    (project
      (name "rabbitmq")
      (url "https://www.rabbitmq.com/")
      (relationship "dependency")
      (description "RabbitMQ message broker")
      (integration "Uses rabbitmqctl/rabbitmqadmin for queue management"))

    (project
      (name "nats")
      (url "https://nats.io/")
      (relationship "dependency")
      (description "NATS messaging system")
      (integration "Uses nats CLI for pub/sub and JetStream"))

    (project
      (name "gen_lsp")
      (url "https://hex.pm/packages/gen_lsp")
      (relationship "dependency")
      (description "Elixir LSP framework")
      (integration "Foundation for LSP server implementation")))

  (potential-extensions
    (extension "Add Apache Kafka adapter")
    (extension "Add AWS SQS/SNS adapter")
    (extension "Add Azure Service Bus adapter")
    (extension "Add Google Cloud Pub/Sub adapter")
    (extension "Add Message tracing and visualization")
    (extension "Add Performance profiling")
    (extension "Add Dead letter queue management")
    (extension "Add Schema validation for messages"))

  (dependencies
    (runtime
      (dependency "Elixir" "~> 1.17")
      (dependency "gen_lsp" "~> 0.10")
      (dependency "jason" "~> 1.4")
      (dependency "redix" "~> 1.5"))

    (development
      (dependency "credo" "~> 1.7")
      (dependency "dialyxir" "~> 1.4")
      (dependency "ex_doc" "~> 0.34")
      (dependency "excoveralls" "~> 0.18")
      (dependency "mox" "~> 1.1"))

    (external-tools
      (tool "redis-cli" "CLI for Redis Streams")
      (tool "rabbitmqctl" "CLI for RabbitMQ management")
      (tool "rabbitmqadmin" "CLI for RabbitMQ admin operations")
      (tool "nats" "CLI for NATS and JetStream")))

  (integration-points
    (integration
      (type "LSP")
      (protocol "Language Server Protocol")
      (interface "stdio/TCP")
      (consumers "VSCode, Neovim, Emacs, any LSP-compatible editor"))

    (integration
      (type "CLI")
      (protocol "Shell commands")
      (interface "System.cmd/3")
      (providers "redis-cli, rabbitmqctl, rabbitmqadmin, nats"))

    (integration
      (type "Supervision")
      (protocol "OTP")
      (interface "GenServer/Supervisor")
      (purpose "Fault isolation and automatic recovery")))

  (philosophy
    (principle "Polyglot messaging support")
    (principle "Fault tolerance through supervision")
    (principle "Simple CLI-based integration")
    (principle "Consistent API across queue systems")
    (principle "IDE-native queue management")))

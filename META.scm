;; SPDX-License-Identifier: PMPL-1.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

(meta
  (project-identity
    (name "poly-queue-lsp")
    (tagline "Language Server for Message Queue Management")
    (category "Developer Tools")
    (domain "Message Queuing"))

  (architecture-decisions
    (adr
      (id "ADR-001")
      (title "Use CLI Tools Instead of Native Libraries")
      (status "accepted")
      (date "2026-02-05")
      (context
        "Need to support multiple message queue systems with minimal dependencies")
      (decision
        "Use CLI tools (redis-cli, rabbitmqctl, nats) instead of native Elixir libraries")
      (rationale
        "CLI tools are universally available and well-maintained"
        "Avoids version conflicts between queue client libraries"
        "Simplifies deployment and reduces binary size"
        "Users already have these tools installed"
        "Easier to debug with familiar CLI commands")
      (consequences
        "Slightly higher latency due to shell execution"
        "Simpler dependency management"
        "Better compatibility across queue versions"
        "Easier to add new queue systems"))

    (adr
      (id "ADR-002")
      (title "Isolated GenServer Per Adapter")
      (status "accepted")
      (date "2026-02-05")
      (context
        "Need fault isolation between different queue system adapters")
      (decision
        "Run each adapter (Redis, RabbitMQ, NATS) as separate supervised GenServer")
      (rationale
        "Crash in one adapter doesn't affect others"
        "BEAM VM provides built-in supervision and recovery"
        "Concurrent operations across queue systems"
        "Clear separation of concerns")
      (consequences
        "Minimal memory overhead per adapter"
        "Automatic recovery from adapter crashes"
        "Easier to test adapters in isolation"
        "Better observability per queue system"))

    (adr
      (id "ADR-003")
      (title "Common Adapter Behaviour")
      (status "accepted")
      (date "2026-02-05")
      (context
        "Need consistent API across different message queue systems")
      (decision
        "Define PolyQueue.Adapters.Behaviour with 8 callbacks")
      (rationale
        "Provides unified interface regardless of underlying queue system"
        "Makes it easy to add new adapters"
        "LSP server can work with any adapter without changes"
        "Clear contract for adapter implementations")
      (consequences
        "All adapters must implement same callbacks"
        "Some queue-specific features may not fit common API"
        "Easier to swap queue systems in projects"
        "Consistent LSP experience across queues")))

  (development-practices
    (principle
      (name "Fault Tolerance First")
      (description "Leverage BEAM VM supervision for automatic recovery")
      (rationale "Message queue systems can be unreliable; handle failures gracefully"))

    (principle
      (name "CLI-First Integration")
      (description "Use standard CLI tools instead of native libraries")
      (rationale "Better compatibility and simpler deployment"))

    (principle
      (name "Minimal Dependencies")
      (description "Keep dependency tree small and focused")
      (rationale "Easier to maintain and less likely to break"))

    (coding-standard
      (rule "Use SPDX headers in all files")
      (rule "Follow Elixir formatting with mix format")
      (rule "Document all public functions with @doc")
      (rule "Include typespecs for behaviour callbacks")))

  (design-rationale
    (decision "Why Elixir/OTP?")
    (reasoning
      "BEAM VM provides built-in fault tolerance"
      "Lightweight processes perfect for adapter isolation"
      "Erlang's history in telecom makes it ideal for message queues"
      "gen_lsp library provides solid LSP foundation")

    (decision "Why support multiple queue systems?")
    (reasoning
      "Different projects use different queues"
      "Redis Streams for simple use cases"
      "RabbitMQ for enterprise requirements"
      "NATS for cloud-native deployments"
      "Single LSP for all queues improves developer experience"))

  (governance
    (license "PMPL-1.0-or-later")
    (author "Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>")
    (repository "https://github.com/hyperpolymath/poly-queue-lsp")
    (contribution-model "Open to contributions via PRs")))

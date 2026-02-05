;; SPDX-License-Identifier: PMPL-1.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

(state
  (metadata
    (project-name "poly-queue-lsp")
    (version "0.1.0")
    (created "2026-02-05")
    (last-updated "2026-02-05")
    (language "Elixir")
    (license "PMPL-1.0-or-later"))

  (project-context
    (purpose "Language Server Protocol implementation for message queue management")
    (description "Provides IDE integration for Redis Streams, RabbitMQ, and NATS message queues")
    (architecture "Elixir OTP application with supervised adapter processes")
    (key-features
      "Auto-detection of queue systems"
      "Publish/subscribe operations"
      "Queue management (list, status, purge)"
      "Consumer group support"
      "Fault-isolated adapters"))

  (current-position
    (milestone "Initial Implementation")
    (completion-percentage 80)
    (status "Nearly Complete")
    (recent-work
      "Created project structure based on poly-ssg-lsp template"
      "Implemented adapter behaviour with 8 callbacks"
      "Created Redis Streams adapter (redis-cli)"
      "Created RabbitMQ adapter (rabbitmqctl/rabbitmqadmin)"
      "Created NATS adapter (nats CLI with JetStream support)"
      "Written comprehensive README.adoc"))

  (route-to-mvp
    (completed-milestones
      (milestone "Project Setup" (completion 100))
      (milestone "Adapter Behaviour" (completion 100))
      (milestone "Redis Streams Adapter" (completion 100))
      (milestone "RabbitMQ Adapter" (completion 100))
      (milestone "NATS Adapter" (completion 100))
      (milestone "Documentation" (completion 100)))

    (remaining-milestones
      (milestone "VSCode Extension" (completion 0))
      (milestone "LSP Server Implementation" (completion 0))
      (milestone "Tests" (completion 0))
      (milestone "CI/CD" (completion 0))))

  (blockers-and-issues
    (current-blockers
      "Need to implement LSP server handlers"
      "Need to create VSCode extension scaffold"
      "Need to write tests for adapters"
      "Need to add GitHub Actions workflows"))

  (critical-next-actions
    (action "Create LSP server module" (priority "high"))
    (action "Implement completion handler" (priority "high"))
    (action "Implement diagnostics handler" (priority "high"))
    (action "Create VSCode extension scaffold" (priority "medium"))
    (action "Write adapter tests" (priority "medium"))
    (action "Add CI/CD workflows" (priority "medium"))
    (action "Initialize git repository" (priority "high")))

  (session-history
    (session
      (date "2026-02-05")
      (work-done
        "Created poly-queue-lsp project from poly-ssg-lsp template"
        "Implemented PolyQueue.Adapters.Behaviour with 8 callbacks"
        "Created Redis Streams adapter with XADD/XREAD support"
        "Created RabbitMQ adapter with rabbitmqctl/rabbitmqadmin"
        "Created NATS adapter with JetStream support"
        "Written README.adoc with usage examples"
        "Set up OTP application structure")
      (blockers-resolved
        "None - initial setup session")
      (notes
        "Project ready for LSP implementation phase"
        "All three adapters support core operations"
        "Need to add comprehensive tests next"))))

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project structure based on poly-ssg-lsp template
- `PolyQueue.Adapters.Behaviour` with 8 callbacks
- Redis Streams adapter using redis-cli
- RabbitMQ adapter using rabbitmqctl/rabbitmqadmin
- NATS adapter using nats CLI with JetStream support
- OTP application with supervised adapters
- VSCode extension scaffold
- Comprehensive README.adoc with usage examples
- Checkpoint files (STATE.scm, META.scm, ECOSYSTEM.scm)

## [0.1.0] - 2026-02-05

### Added
- Initial release with basic queue management functionality

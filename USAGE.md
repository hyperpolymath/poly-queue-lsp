# Usage Guide

> Comprehensive guide for using poly-queue-lsp across VSCode, Neovim, and Emacs

## Table of Contents

- [VSCode Setup](#vscode-setup)
- [Neovim Setup](#neovim-setup)
- [Emacs Setup](#emacs-setup)
- [Configuration](#configuration)
- [Commands](#commands)
- [Troubleshooting](#troubleshooting)
- [Adapter-Specific Notes](#adapter-specific-notes)

## VSCode Setup

### Installation

1. **Install the LSP Server:**
   ```bash
   git clone https://github.com/hyperpolymath/poly-queue-lsp.git
   cd poly-queue-lsp
   ./install.sh
   ```

2. **Install VSCode Extension:**
   ```bash
   cd vscode-extension
   npm install
   npm run compile
   code --install-extension *.vsix
   ```

### Features

The VSCode extension provides:

- **Multi-Queue Support**: Redis Streams, RabbitMQ, NATS
- **Message Schema Validation**: Message formats, routing keys
- **Diagnostics**: Configuration errors, connection issues
- **Hover Documentation**: Queue stats, message info
- **Commands**: Publish, consume, inspect queues directly from editor

### Available Commands

Access via Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`):

- **Queue: Publish Message** - Send message to queue
- **Queue: Consume Messages** - Receive messages
- **Queue: List Queues** - Show all queues/streams
- **Queue: Inspect Queue** - View queue details
- **Queue: Purge Queue** - Clear queue messages
- **Queue: Delete Queue** - Remove queue
- **Queue: Monitor** - Watch queue activity

### Settings

Add to your workspace or user `settings.json`:

```json
{
  "lsp.serverPath": "/path/to/poly-queue-lsp",
  "lsp.trace.server": "verbose",
  "lsp.queue.system": "auto",
  "lsp.queue.validateOnSave": true,
  "lsp.queue.enableMonitoring": true
}
```

## Neovim Setup

### Using nvim-lspconfig

Add to your Neovim configuration:

```lua
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

-- Register poly-queue-lsp if not already defined
if not configs.poly_queue_lsp then
  configs.poly_queue_lsp = {
    default_config = {
      cmd = {'/path/to/poly-queue-lsp/_build/prod/rel/poly_queue_lsp/bin/poly_queue_lsp'},
      filetypes = {'yaml', 'json'},
      root_dir = lspconfig.util.root_pattern(
        'redis.conf',
        'rabbitmq.conf',
        'nats.conf',
        'queue-config.yaml'
      ),
      settings = {
        queue = {
          system = 'auto',
          validateOnSave = true,
          enableMonitoring = true
        }
      }
    }
  }
end

-- Setup the LSP
lspconfig.poly_queue_lsp.setup({
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- Custom commands
    vim.api.nvim_buf_create_user_command(bufnr, 'QueuePublish', function()
      vim.lsp.buf.execute_command({command = 'queue.publish'})
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, 'QueueList', function()
      vim.lsp.buf.execute_command({command = 'queue.list'})
    end, {})
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})
```

## Emacs Setup

### Using lsp-mode

Add to your Emacs configuration:

```elisp
(use-package lsp-mode
  :hook ((yaml-mode json-mode) . lsp)
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     '("/path/to/poly-queue-lsp/_build/prod/rel/poly_queue_lsp/bin/poly_queue_lsp"))
    :major-modes '(yaml-mode json-mode)
    :server-id 'poly-queue-lsp
    :initialization-options (lambda ()
                             '(:system "auto"
                               :validateOnSave t)))))

;; Custom commands
(defun queue-publish ()
  "Publish message to queue."
  (interactive)
  (lsp-execute-command "queue.publish"))

(defun queue-list ()
  "List all queues."
  (interactive)
  (lsp-execute-command "queue.list"))

(define-key lsp-mode-map (kbd "C-c m p") 'queue-publish)
(define-key lsp-mode-map (kbd "C-c m l") 'queue-list)
```

## Configuration

### Server Configuration

Create `.poly-queue-lsp.json` in your project root:

```json
{
  "queue": {
    "system": "redis",
    "validateOnSave": true,
    "enableMonitoring": true
  },
  "redis": {
    "host": "localhost",
    "port": 6379,
    "db": 0,
    "password": "",
    "enableStreams": true
  },
  "rabbitmq": {
    "host": "localhost",
    "port": 5672,
    "username": "guest",
    "password": "guest",
    "vhost": "/"
  },
  "nats": {
    "url": "nats://localhost:4222",
    "enableJetStream": true
  }
}
```

### Environment Variables

```bash
# Redis
export REDIS_URL=redis://localhost:6379/0
export REDIS_PASSWORD=

# RabbitMQ
export RABBITMQ_URL=amqp://guest:guest@localhost:5672/
export RABBITMQ_HOST=localhost
export RABBITMQ_PORT=5672

# NATS
export NATS_URL=nats://localhost:4222
export NATS_TOKEN=
```

## Commands

### LSP Commands

#### queue.publish
Publish message to queue.

**Parameters:**
- `queue`: Queue/stream name
- `message`: Message content
- `key` (optional): Routing key

**Returns:** Message ID

**Example (Neovim):**
```lua
vim.lsp.buf.execute_command({
  command = 'queue.publish',
  arguments = {{
    queue = 'my-stream',
    message = '{"data": "value"}',
    key = 'my-key'
  }}
})
```

#### queue.consume
Consume messages from queue.

**Parameters:**
- `queue`: Queue/stream name
- `count` (optional): Number of messages

**Returns:** Message list

#### queue.list
List all queues or streams.

**Parameters:** None

**Returns:** Queue list with stats

#### queue.inspect
Inspect queue details.

**Parameters:**
- `queue`: Queue/stream name

**Returns:** Queue information (message count, consumers, etc.)

#### queue.purge
Clear all messages from queue.

**Parameters:**
- `queue`: Queue/stream name

**Returns:** Purge status

#### queue.delete
Delete queue.

**Parameters:**
- `queue`: Queue/stream name

**Returns:** Delete status

## Troubleshooting

### Connection Errors

**Symptoms:** "Unable to connect to queue system" error.

**Solutions:**

1. **Verify services are running:**
   ```bash
   # Redis
   redis-cli ping

   # RabbitMQ
   rabbitmqctl status

   # NATS
   nats-server --version
   ```

2. **Check connectivity:**
   ```bash
   # Redis
   redis-cli -h localhost -p 6379

   # RabbitMQ
   rabbitmqadmin list queues

   # NATS
   nats stream ls
   ```

### Authentication Errors

**Symptoms:** "Authentication failed" error.

**Solutions:**

1. **Verify credentials:**
   ```bash
   # Redis
   redis-cli -a password ping

   # RabbitMQ
   rabbitmqctl authenticate_user guest guest

   # NATS
   nats account info
   ```

## Adapter-Specific Notes

### Redis Streams

**Detection:** Redis server on port 6379 or `redis.conf` file

**Features:**
- Stream creation and management
- Consumer group support
- Message publishing/consuming
- Stream trimming
- Pending messages inspection

**Configuration:**
```json
{
  "adapters": {
    "redis": {
      "host": "localhost",
      "port": 6379,
      "db": 0,
      "password": "",
      "enableStreams": true,
      "maxLen": 1000
    }
  }
}
```

**Known Issues:**
- Cluster mode requires additional configuration
- Stream trimming may impact message delivery

### RabbitMQ

**Detection:** RabbitMQ server on port 5672 or `rabbitmq.conf` file

**Features:**
- Exchange management (direct, topic, fanout, headers)
- Queue creation and binding
- Message routing
- Dead letter exchanges
- TTL configuration

**Configuration:**
```json
{
  "adapters": {
    "rabbitmq": {
      "host": "localhost",
      "port": 5672,
      "username": "guest",
      "password": "guest",
      "vhost": "/",
      "enableManagement": true
    }
  }
}
```

**Known Issues:**
- Management plugin required for full features
- Cluster setups may need load balancer configuration

### NATS

**Detection:** NATS server on port 4222 or `nats.conf` file

**Features:**
- JetStream support
- Stream and consumer management
- Key-value store
- Object store
- Request-reply patterns

**Configuration:**
```json
{
  "adapters": {
    "nats": {
      "url": "nats://localhost:4222",
      "token": "",
      "enableJetStream": true,
      "enableKV": true
    }
  }
}
```

**Known Issues:**
- JetStream requires explicit enablement
- Cluster mode requires seed servers configuration

## Additional Resources

- **GitHub Repository:** https://github.com/hyperpolymath/poly-queue-lsp
- **Issue Tracker:** https://github.com/hyperpolymath/poly-queue-lsp/issues
- **Examples:** See `examples/` directory for sample configurations

## License

PMPL-1.0-or-later

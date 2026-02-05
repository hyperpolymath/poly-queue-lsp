// SPDX-License-Identifier: PMPL-1.0-or-later
// SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

import * as vscode from 'vscode';
import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
} from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: vscode.ExtensionContext) {
  console.log('PolyQueue LSP extension is now active');

  // Get configuration
  const config = vscode.workspace.getConfiguration('polyqueue');
  const serverPath = config.get<string>('lsp.serverPath') || 'mix';

  // Server options
  const serverOptions: ServerOptions = {
    command: serverPath,
    args: ['run', '--no-halt'],
    options: {
      cwd: vscode.workspace.rootPath,
    },
  };

  // Client options
  const clientOptions: LanguageClientOptions = {
    documentSelector: [
      { scheme: 'file', language: 'json' },
      { scheme: 'file', language: 'yaml' },
      { scheme: 'file', language: 'toml' },
    ],
    synchronize: {
      fileEvents: vscode.workspace.createFileSystemWatcher('**/*.{json,yaml,yml,toml}'),
    },
  };

  // Create language client
  client = new LanguageClient(
    'polyqueueLsp',
    'PolyQueue LSP',
    serverOptions,
    clientOptions
  );

  // Register commands
  registerCommands(context);

  // Start the client
  client.start();
}

export function deactivate(): Thenable<void> | undefined {
  if (!client) {
    return undefined;
  }
  return client.stop();
}

function registerCommands(context: vscode.ExtensionContext) {
  // List queues command
  context.subscriptions.push(
    vscode.commands.registerCommand('polyqueue.listQueues', async () => {
      const result = await client.sendRequest('polyqueue/listQueues', {});
      vscode.window.showInformationMessage(`Queues: ${JSON.stringify(result)}`);
    })
  );

  // Queue status command
  context.subscriptions.push(
    vscode.commands.registerCommand('polyqueue.queueStatus', async () => {
      const queueName = await vscode.window.showInputBox({
        prompt: 'Enter queue name',
        placeHolder: 'queue-name',
      });

      if (queueName) {
        const result = await client.sendRequest('polyqueue/queueStatus', {
          queueName,
        });
        vscode.window.showInformationMessage(
          `Queue Status: ${JSON.stringify(result)}`
        );
      }
    })
  );

  // Publish message command
  context.subscriptions.push(
    vscode.commands.registerCommand('polyqueue.publish', async () => {
      const queueName = await vscode.window.showInputBox({
        prompt: 'Enter queue name',
        placeHolder: 'queue-name',
      });

      if (!queueName) return;

      const message = await vscode.window.showInputBox({
        prompt: 'Enter message',
        placeHolder: '{"key": "value"}',
      });

      if (message) {
        const result = await client.sendRequest('polyqueue/publish', {
          queueName,
          message,
        });
        vscode.window.showInformationMessage(`Published: ${result}`);
      }
    })
  );

  // Subscribe command
  context.subscriptions.push(
    vscode.commands.registerCommand('polyqueue.subscribe', async () => {
      const queueName = await vscode.window.showInputBox({
        prompt: 'Enter queue name',
        placeHolder: 'queue-name',
      });

      if (queueName) {
        const result = await client.sendRequest('polyqueue/subscribe', {
          queueName,
          count: 10,
        });
        const outputChannel = vscode.window.createOutputChannel('PolyQueue');
        outputChannel.appendLine(`Messages from ${queueName}:`);
        outputChannel.appendLine(JSON.stringify(result, null, 2));
        outputChannel.show();
      }
    })
  );

  // Purge queue command
  context.subscriptions.push(
    vscode.commands.registerCommand('polyqueue.purgeQueue', async () => {
      const queueName = await vscode.window.showInputBox({
        prompt: 'Enter queue name to purge',
        placeHolder: 'queue-name',
      });

      if (queueName) {
        const confirm = await vscode.window.showWarningMessage(
          `Are you sure you want to purge queue "${queueName}"? This cannot be undone.`,
          'Yes',
          'No'
        );

        if (confirm === 'Yes') {
          const result = await client.sendRequest('polyqueue/purgeQueue', {
            queueName,
          });
          vscode.window.showInformationMessage(`Queue purged: ${result}`);
        }
      }
    })
  );
}

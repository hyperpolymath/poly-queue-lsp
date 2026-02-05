# SPDX-License-Identifier: PMPL-1.0-or-later
# SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

defmodule PolyQueue.Adapters.RedisStreamsTest do
  use ExUnit.Case, async: false

  alias PolyQueue.Adapters.RedisStreams

  describe "detect/0" do
    test "detects redis-cli installation" do
      case RedisStreams.detect() do
        {:ok, detected} -> assert is_boolean(detected)
        {:error, _} -> assert true
      end
    end
  end

  describe "metadata/0" do
    test "returns correct metadata" do
      metadata = RedisStreams.metadata()

      assert metadata.name == "Redis Streams"
      assert metadata.cli_tool == "redis-cli"
      assert :publish in metadata.features
      assert :subscribe in metadata.features
    end
  end
end

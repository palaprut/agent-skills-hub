# Discord MCP on Windows

This local MCP server uses a Discord bot for one server. It can list readable text channels, read message history, and post text when explicitly requested. It uses MCP over stdio.

## Restore the setup

1. Create or reuse a bot in the Discord Developer Portal and install it to the intended Discord server. Grant **View Channel** and **Read Message History** in the channels it should read. Add **Send Messages** only where it should post. Enable **Message Content Intent** if the bot needs to read regular message bodies and Discord permits it for the app. [Discord bot setup](https://docs.discord.com/developers/quick-start/getting-started) · [Permissions](https://docs.discord.com/developers/topics/permissions) · [Message Content Intent](https://docs.discord.com/developers/events/gateway#message-content-intent)
2. Copy [`server.py`](server.py) to a local folder such as `C:\Tools\DiscordMCP`. In that local copy, replace `YOUR_DISCORD_SERVER_ID` with the numeric server ID from Discord Developer Mode.
3. In PowerShell, create the environment with Python 3.10 or newer and install the versions used by the backed-up setup.

   ```powershell
   Set-Location 'C:\Tools\DiscordMCP'
   python -m venv venv
   .\venv\Scripts\python.exe -m pip install 'mcp==1.30.0' 'keyring==25.7.0'
   ```

4. Store the bot token for the Windows account that will run the harness. Replace the placeholder with the same numeric server ID and enter the token at the prompt. Keep the token in Windows Credential Manager.

   ```powershell
   .\venv\Scripts\python.exe -m keyring set 'OpenAI DiscordMCP' 'YOUR_DISCORD_SERVER_ID'
   ```

5. In Codex, add or update the `discord` entry in `~/.codex/config.toml` using the actual absolute paths. In another harness, register the same executable and script argument as a local stdio MCP server. [Codex MCP configuration](https://developers.openai.com/codex/mcp)

   ```toml
   [mcp_servers.discord]
   command = 'C:\Tools\DiscordMCP\venv\Scripts\python.exe'
   args = ['C:\Tools\DiscordMCP\server.py']
   ```

6. Start a fresh session and run `list_channels`. Check that it returns the expected channels from the configured server. Use `read_messages` on a channel you intend to read. Use `send_message` only when explicitly requested for the destination.

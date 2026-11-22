import json
from urllib.error import HTTPError
from urllib.request import Request, urlopen

import keyring
from mcp.server.fastmcp import FastMCP

GUILD_ID = "YOUR_DISCORD_SERVER_ID"
SERVICE = "OpenAI DiscordMCP"
mcp = FastMCP("Discord")


def discord(path, payload=None):
    token = keyring.get_password(SERVICE, GUILD_ID)
    if not token:
        raise ValueError("Set the Discord bot token in Windows Credential Manager first.")
    headers = {"Authorization": f"Bot {token}", "User-Agent": "DiscordBot (https://discord.com, 1.0)"}
    body = None
    if payload is not None:
        headers["Content-Type"] = "application/json"
        body = json.dumps(payload).encode()
    request = Request(f"https://discord.com/api/v10{path}", data=body, headers=headers)
    try:
        with urlopen(request, timeout=20) as response:
            return json.load(response)
    except HTTPError as error:
        raise ValueError(f"Discord returned HTTP {error.code}. Check the bot token and channel permissions.") from None


def check_channel(channel_id):
    if not channel_id.isascii() or not channel_id.isdecimal():
        raise ValueError("Use a numeric Discord channel ID.")
    channel = discord(f"/channels/{channel_id}")
    if channel.get("guild_id") != GUILD_ID:
        raise ValueError("This channel is outside the configured Discord server.")
    return channel


@mcp.tool(annotations={"readOnlyHint": True, "openWorldHint": True})
def list_channels():
    """List readable text and announcement channels in the configured Discord server."""
    bot_id = discord("/users/@me")["id"]
    role_ids = set(discord(f"/guilds/{GUILD_ID}/members/{bot_id}")["roles"])
    base = 0
    for role in discord(f"/guilds/{GUILD_ID}/roles"):
        if role["id"] == GUILD_ID or role["id"] in role_ids:
            base |= int(role["permissions"])

    channels = []
    for channel in discord(f"/guilds/{GUILD_ID}/channels"):
        if channel["type"] not in (0, 5):
            continue
        permissions = base
        if not (base & (1 << 3)):
            overwrites = channel.get("permission_overwrites", [])
            for targets in ({GUILD_ID}, role_ids, {bot_id}):
                allowed = denied = 0
                for overwrite in overwrites:
                    if overwrite["id"] in targets:
                        allowed |= int(overwrite["allow"])
                        denied |= int(overwrite["deny"])
                permissions = (permissions & ~denied) | allowed
            if permissions & 0x10400 != 0x10400:
                continue
        channels.append({key: channel.get(key) for key in ("id", "name", "parent_id")})
    return channels


@mcp.tool(annotations={"readOnlyHint": True, "openWorldHint": True})
def read_messages(channel_id: str, limit: int = 20, before: str | None = None):
    """Read Discord message history. Use before with a message ID to read older messages."""
    if not 1 <= limit <= 100:
        raise ValueError("Limit must be between 1 and 100.")
    if before is not None and (not before.isascii() or not before.isdecimal()):
        raise ValueError("Use a numeric Discord message ID for before.")
    check_channel(channel_id)
    query = f"limit={limit}"
    if before:
        query += f"&before={before}"
    return discord(f"/channels/{channel_id}/messages?{query}")


@mcp.tool(annotations={"readOnlyHint": False, "destructiveHint": False, "idempotentHint": False, "openWorldHint": True})
def send_message(channel_id: str, content: str):
    """Post text as the Discord bot. Use only when the user explicitly requests sending to the destination."""
    if not content.strip() or len(content.encode("utf-16-le")) // 2 > 2000:
        raise ValueError("Provide a nonempty Discord message of up to 2000 characters.")
    check_channel(channel_id)
    message = discord(f"/channels/{channel_id}/messages", {"content": content, "allowed_mentions": {"parse": []}})
    return {"id": message["id"], "url": f"https://discord.com/channels/{GUILD_ID}/{channel_id}/{message['id']}"}


if __name__ == "__main__":
    mcp.run()

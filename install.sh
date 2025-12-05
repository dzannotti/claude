rm -rf ~/.claude
ln -s . ~/.claude
claude mcp add --transport http context7 https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: YOUR_API_KEY"
claude mcp add sequential-thinking npx -y @modelcontextprotocol/server-sequential-thinking


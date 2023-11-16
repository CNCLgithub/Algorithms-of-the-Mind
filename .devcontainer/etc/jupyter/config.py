c = get_config()

# Broadcast on the container so that it's accessible by the host system
c.ServerApp.ip = "0.0.0.0"
# 2686 = AOTM
c.ServerApp.port = 2686

# c.ServerApp.root_dir = "/algorithms-of-the-mind"
c.ServerApp.preferred_dir = "/algorithms-of-the-mind"

c.ServerApp.terminals_enabled = True

# ! Don't open the browser
c.ServerApp.open_browser = False
c.ExtensionApp.open_browser = False

# ! Allow passwordless entry, since it's a local instance
c.PasswordIdentityProvide.hashed_password = ""
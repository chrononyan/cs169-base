# cs169-base

A Docker base image for Berkeley CS169 projects. Because I really don't want Ruby screwing with my system.

```
# Build the image
docker build -t cs169-base .

# Copy your GitHub SSH private key over
cp path/to/id_rsa .ssh_key

# Set your Heroku token
(heroku auth:whoami || heroku auth:login) && echo "HEROKU_API_KEY=$(heroku auth:token)" > .env

# Create a container
docker create --env-file .env -p 8080:3000 --name cs169-proj1 -it cs169-base /bin/bash

# Usage
docker start cs169-proj1
docker exec -it cs169-proj1 /bin/bash # You can have multiple shell sessions at once! Just open more terminals and run this again

# Usage: inside the container
curl -sSL https://raw.githubusercontent.com/saasbook/courseware/master/verify-setup.sh | bash # if you want to verify setup
git clone git@github.com:path/to/repo /app
rails server -b 0.0.0.0 # hack away
```

### Notes

- Defaults to Ruby 2.7, can change the first line of the `Dockerfile` (e.g. `FROM ruby:2.6`)
- Mocks RVM to bypass check in `saasbook/courseware/verify-setup.sh`. Because who needs RVM when you can just spin up another container
- If you're on Linux it may be worth cloning the app outside the container and mounting it as a volume (add `-v path/to/clone:/app` to `docker create`). Docker for macOS/Windows has horrible mount performance though, don't bother there
- The example `docker create` forwards port `8080` on the host to port `3000` in the container. Your app might use different port(s)
- Doesn't install deps for building native gems, because we haven't been forced to use them yet

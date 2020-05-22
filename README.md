# Shell-Scripts

This is a repository of my personal bash scripts.

## update-compose

This is a script to update my docker-compose files from a private repository and run docker-compose on them. It checks the paramter list given to see if any are valid servers (this is defined in the code), sshs into them, pulls the latest changes to docker-compose and environment files from a git repo, copies them into the appropriate places, and runs `docker-compose up -d`.
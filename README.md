# Skynet
![skynet](priv/static/images/skynet.png)
# The Game 

The exercise is to model Skynet and Terminators using Elixir. A user can spawn Terminators and then those Terminators go on living their metallic, human-killing lives. Each Terminator has a chance to reproduce and be killed by Sarah Connor at specific intervals.

- Take advantage of Elixir's OTP features.
- When the app starts there should be no Terminators.
- There should be a function that when called spawns a Terminator.
    - While this terminator is alive, it has a chance to reproduce and be killed by Sarah Connor.
    - Every 5 seconds, each terminator has a 20% chance of reproducing, creating 1 new terminator.
        - Terminators can reproduce more than once. They're trying to take over the world, after all.
    - Every 10 seconds, each terminator has a 25% chance to be killed by Sarah Connor.
- Each terminator should have a unique ID.
- There should be a function to manually kill a Terminator given its ID.
- There should be a function to get a list of all living Terminators.
- You don't need to keep track of ancestry / hierarchy.
- Expect this part to be run and manually tested in `iex`.

### The API
Create API endpoints for the following actions. You can pick what API protocol to use, if any.

- Spawn a terminator
- Manually kill a terminator
- List all living terminators


# Installation 
  Follow the instructions to install Elixir 1.18.3-otp-27 [Elixir Lang Org Page](https://elixir-lang.org/install.html) 
  If you have a different version of Elixir installed, I recommend using asdf for version management. 
  For more information visit [asdf homepage](https://asdf-vm.com/guide/getting-started.html)

### Elixir/Phoenix
  Follow the [Phoenix](https://hexdocs.pm/phoenix/installation.html) installation guide to install all the required dependencies.

  * This application requires Elixir version 1.18.3-otp-27 [Elixir Lang Org Page](https://elixir-lang.org/install.html) and Erlang version 27.3.1
  * If you have a different version of Elixir and Erlang installed, I recommend using asdf for version management. For more information visit [asdf homepage](https://asdf-vm.com/guide/getting-started.html)


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

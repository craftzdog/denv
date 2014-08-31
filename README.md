# Denv - Environment Builder Using Docker for Client-side Application

Denv helps building Docker container for testing/development of client-side application.

## Installation

Add this line to your application's Gemfile:

    gem 'denv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install denv


## Usage

Denv can build containers automatically by reading the instructions from a `Denvfile`.
A `Denvfile` is a text document that contains all options for building and running a container.

To run a container from a source repository, create a description file called `Dockerfile` at the root of your repository. This file will describe how to run the container.
Then call `denv up`:

	$ denv up -t xcconfig -o Denv.xcconfig


## Configuration

You can generate template with following command:

	$ denv init IMAGE

The IMAGE is a name of docker container image.

### Available settings

`docker.url` - The URL to docker daemon.

`container.create_param` - The parameters which are passed to `create` API of Docker.
See [this documentation](https://docs.docker.com/reference/api/docker_remote_api_v1.14/#create-a-container).

`container.start_param` - The parameters which are passed to `start` API of Docker.
See [this documentation](https://docs.docker.com/reference/api/docker_remote_api_v1.14/#start-a-container).

`container.on_start` - This configures event handler invoked when the container has been started.

`container.on_destroy` - This configures event handler invoked when the container has been destroyed.



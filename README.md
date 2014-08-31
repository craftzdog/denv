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

## Gemerate XCConfig

If you specified xcconfig to output filetype with `-t` option, it generates `Denv.xcconfig` file which content is like following:

    DOCKER_HOST = docker-host.com
    CONTAINER_ID = bf5abaa741cc870ea3c82edf39dea59dd4ce2b3f316766863e5c332985ae6c70
    CONTAINER_NAME = /thirsty_wilson
    CONTAINER_HOSTNAME = bf5abaa741cc
    CONTAINER_IMAGE = 434484d3b4904ffe418a1525d6df73461d7e9db6f776929ce997b6c517f0ddc4
    CONTAINER_PORT_22 = 49193
    CONTAINER_PORT_9080 = 49194
    CONTAINER_PORT_9081 = 49195

You can use these informations within your xcconfig file like so:

	#include "Denv.xcconfig"
	
	kAPIServerHost = "@\"$(DOCKER_HOST)\""
	kAPIServerPort = $(CONTAINER_PORT_9080)
	
	GCC_PREPROCESSOR_DEFINITIONS = $(inherited) kAPIServerHost=$(kAPIServerHost) kAPIServerPort=$(kAPIServerPort)

The server hostname and port number are given through preprocessor macros, so you can use them in your code:

	NSString url = [NSString stringWithFormat:@"http://%@:%d/", kAPIServerHost, kAPIServerPort];

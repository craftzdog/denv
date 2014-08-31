require 'spec_helper'

describe Denv do
  it 'has a version number' do
    expect(Denv::VERSION).not_to be nil
  end

  it 'generates Denvfile' do
    image_name = 'test/dev'

    Denv::Command.run ['init', image_name]

    conf = Denv::Config.new
    conf.load_from_file

    expect(conf.docker.url).to eq(Denv::DockerUrl)
    expect(conf.container.create_param['Image']).to eq(image_name)
  end

  after(:all) do
    File.delete Denv::DenvFileName
  end

end

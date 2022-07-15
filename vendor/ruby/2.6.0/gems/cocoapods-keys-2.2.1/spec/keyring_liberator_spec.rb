require 'spec_helper'
require 'keyring_liberator'
require 'tmpdir'
require 'keyring'

include CocoaPodsKeys

describe KeyringLiberator do
  it 'should get the keys directory' do
    expect(KeyringLiberator.keys_dir.to_s).to end_with('cocoapods/keys')
  end

  it 'should append a sha + .yaml when getting the yaml path' do
    expect(KeyringLiberator.yaml_path_for_path('test').to_s).to include('cocoapods/keys/')
    expect(KeyringLiberator.yaml_path_for_path('test').to_s).to end_with('098f6bcd4621d373cade4e832627b4f6.yml')
  end

  it 'should find by name' do
    keyring = Keyring.from_hash('name' => 'test', 'path' => 'testpath', 'keys' => [])
    allow(KeyringLiberator).to receive(:get_all_keyrings).and_return([keyring])
    expect(KeyringLiberator.get_keyring_named('test')).to equal(keyring)
  end

  it 'should find many by name' do
    keyring1 = Keyring.from_hash('name' => 'test', 'path' => 'testpath1', 'keys' => [])
    keyring2 = Keyring.from_hash('name' => 'test', 'path' => 'testpath2', 'keys' => [])
    allow(KeyringLiberator).to receive(:get_all_keyrings).and_return([keyring1, keyring2])
    expect(KeyringLiberator.get_all_keyrings_named('test')).to eq([keyring1, keyring2])
  end

  it 'should be nil if nothing found find by name' do
    keyring = Keyring.from_hash('name' => 'test', 'path' => 'testpath', 'keys' => [])
    allow(KeyringLiberator).to receive(:get_all_keyrings).and_return([keyring])
    expect(KeyringLiberator.get_keyring_named('not found')).to be_falsey
  end
end

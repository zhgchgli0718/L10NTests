require 'keyring_liberator'
require 'key_master'
require 'dotenv'

module Pod
  class Command
    class Keys
      class Generate < Keys
        self.summary = 'Generates the obfuscated class.'

        self.description = <<-DESC
          Generates the obfuscated Objective-C h/m files using the current key values.

          An optional operator can be done to force a project name.
        DESC

        self.arguments = [CLAide::Argument.new('project_name', false)]

        def self.options
          [['--keys=key1,key2...', 'An array of keys to add if no keyring is found']].concat(super)
        end

        def initialize(argv)
          @project_name = argv.shift_argument
          @keys = argv.option('keys', '').split(',')
          super
        end

        def run
          Dotenv.load
          keyring = get_current_keyring || CocoaPodsKeys::Keyring.new(@project_name, '/', @keys)

          if keyring

            # Create the h & m files in the same folder as the podspec

            installation_root = Pod::Config.instance.installation_root
            keys_path = installation_root.+('Pods/CocoaPodsKeys/')

            key_master = CocoaPodsKeys::KeyMaster.new(keyring)
            interface_file = keys_path + (key_master.name + '.h')
            implementation_file = keys_path + (key_master.name + '.m')

            File.write(interface_file, key_master.interface)
            UI.puts "Generated #{interface_file}"

            File.write(implementation_file, key_master.implementation)
            UI.puts "Generated #{implementation_file}"

          end
        end
      end
    end
  end
end

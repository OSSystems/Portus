require 'cconfig'

module CConfigWithErb
  def fetch
    cfg   = File.file?(@default) ? YAML.load( ERB.new( File.read( @default ) ).result ) : {}
    local = fetch_local

    hsh = strict_merge_with_env(default: cfg, local: local, prefix: @prefix)
    hsh.extend(::CConfig::HashUtils::Extensions)
    hsh.defaults = cfg
    hsh
  end

  protected
  def fetch_local
    if File.file?(@local)
      # Check for bad user input in the local config.yml file.
      local = YAML.load( ERB.new( File.read( @local ) ).result )
      raise FormatError unless local.is_a?(::Hash)
      local
    else
      {}
    end
  end
end

::CConfig::Config.send(:prepend, CConfigWithErb)

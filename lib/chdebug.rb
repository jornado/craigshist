class CHDebug
  
  def init(env='development')
    @@config = YAML.load_file( './config/craigshist.yml' )
    @@env = env
    @@debug = @@config[@@env]['debug']
  end
  
  protected
  def debug(msg)
    if not @@debug.nil?
      puts msg
    end
  end
  
end
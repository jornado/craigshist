desc "Install gems that this app depends on."
task :install_dependencies do
  dependencies = {
    "sinatra"       => "0.9.4",
    "dm-core"       => "0.9.11",
    "dm-timestamps" => "0.9.11",
    "do_sqlite3"    => "0.9.12",
    "geokit"        => "1.5.0",
    "hpricot"       => "0.8.2",
    "test-unit"     => "2.1.1",
  }
  dependencies.each do |gem_name, version|
    puts "#{gem_name} #{version}"
    system "gem install #{gem_name} --version #{version}"
  end
end

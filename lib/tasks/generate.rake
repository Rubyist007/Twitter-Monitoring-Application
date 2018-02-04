namespace :g do
  desc 'Generate migration'
  task :migration do
    name = ARGV[1].downcase.plural || raise('You forgot specify name, command must be like that: rake g:migration your_migration_name')
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    path = File.expand_path("./db/migrate/#{timestamp}_#{name}.rb")
    migration_class = name.split('_').map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[4.2]
  def change
  end
end
      EOF
    end

    p "Migration #{timestamp}_#{name}.rb created"
    abort
  end
end

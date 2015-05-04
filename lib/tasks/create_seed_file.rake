desc 'create the seeds.rb file'
task :create_seed_data_file => :environment do
  i = 0
  File.open(Rails.root.join("db","data", "listings.json"), 'w') do |f|
    f.puts JSON.pretty_generate(BoatListing.all.as_json)
  end
  puts "Seed data file created."
end

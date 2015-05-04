BoatListing.destroy_all
puts "Cleared out listings. Reloading..."
seed_data = Rails.root.join("db","data","listings.json")

listings = JSON.load(File.read(seed_data))
i = 0
listings.each do |attrs|
  BoatListing.create!(attrs)
  i += 1
  puts "#{i} listings loaded" if i % 1000 == 0
end
puts "Finished loading #{BoatListing.count} listings."

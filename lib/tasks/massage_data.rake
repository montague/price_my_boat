desc "grab the ids from data/65k_used_us_60ft.original.html"
task :harvest_ids => :environment do
  puts "Running this will destroy boat listing data. You sure? If yes, uncomment the code."
  #puts "harvesting some shit"
  #file = 'data/original_files/id_string'
  #delimiter = "&checked="
  #ids = File.read(file).split(delimiter)
  #ids.shift # first entry is blank
  #puts "ids harvested, deleting and repopulating entries"
  #BoatListing.destroy_all
  #ids.each do |id|
    #BoatListing.create!(:yw_id => id)
  #end
  #puts "Created #{BoatListing.count} boat listings."
end

task :import_yacht_data => :environment do
  # batch request the details for groups of boats
  # start at 250 ids per request
  # parse the returned html and dump each chunk into the
  # db for its associated id
  #prefix = "http://services.soldboats.com/listing/sb_boat_detail.jsp?currency=USD&units=Feet"
  #"&id=2306216&id=2444204&id=2392843&id=1999274&id=1689968&id=2510011&id=2390738&id=2478745&id=2476355&id=2293892&id=2496547&id=2407066&id=2496161&id=1474606&id=2499889&id=2133877&id=2182921&id=2217584&id=2262878&id=1073539&id=2240622&id=2022649&id=2376986&id=1614048&id=2465650&id=2446880&id=2407430&id=2283017&id=2435720&id=2416976&id=2209027&id=2468096&id=1746163&id=2117047&id=2102908&id=2426688&id=2382882&id=2547965&id=1321613&id=2436960&id=2381699&id=2134451&id=2148784&id=2468301&id=2002184&id=2120695&id=2455940&id=2343691&id=2613356&id=2240086&id=1452891&id=2443141&id=2520302&id=2373170&id=2444829&id=2259990&id=2246597&id=1804689&id=2241040&id=1959303&id=2622189&id=2223636&id=2518815&id=2449539&id=2513774&id=2531835&id=2507226&id=2434255&id=2400538&id=2269054&id=2303539&id=2367385&id=2128713&id=2392337&id=2347895&id=1912177&id=2489496&id=2350356&id=2208831&id=2179311&id=2247597&id=2198914&id=1956358&id=2433457&id=2517225&id=2278823&id=2482977&id=2453944&id=2364025&id=2427310&id=2502024&id=2420842&id=2292931&id=2241671&id=2089957&id=2132497&id=2253775&id=2364957&id=2263512&id=2427265&lang=en&robw=&url=norviewmarina&
  puts "This is destructive. Make sure you want to do this. Uncomment to activate."
  #count = 0
  #BoatListing.all.find_in_batches(:batch_size => 250) do |batch|
    #ids = '&id=' + batch.map(&:yw_id).join('&id=')
    #command = "curl 'http://services.soldboats.com/listing/sb_boat_detail.jsp?currency=USD&units=Feet#{ids}&lang=en&robw=&url=norviewmarina&' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: services.soldboats.com' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Referer: http://services.soldboats.com/listing/cache/sb_sold_results.jsp?slim=soldboats&cit=true&sm=3&searchPage=%2Flisting%2Fcache%2Fsb_search_page2.jsp&robw=&url=norviewmarina&is=false&man=&type=%28Power%29&fromSDint=&fromSDmon=1&fromSDyr=2011&toSDmon=12&toSDyr=&fromLength=&toLength=60&luom=126&fromYear=&toYear=&fromPrice=&toPrice=&currencyid=100&hmid=0&ftid=0&enid=0&city=&cint=100&spid=&rid=&ywbid=&ps=100&bn=&includeSoldComments=' -H 'Cookie: yw_c_id=6463141845772067354; s_nr=1377647953502; JSESSIONID=399B6EDD8155848055B6E88AFA37E622.soldboats1; s_vnum=1380239949691%26vn%3D9; ev_9=event9; s_cc=true; s_evar2=12%3A30PM; s_evar3=Sunday; s_evar4=Weekend; s_lv=1379868086454; s_lv_s=More%20than%207%20days; s_invisit=true; s_sq=%5B%5BB%5D%5D' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed > data/batched_extended_data/#{count}.data.html"
    #puts `#{command}`
    #count += 1
    #puts "downloaded #{count * 250} so far..."
  #end
  #puts "file's done."
end

task :import_extended_data => :environment do
  BoatHtmlListParser.populate_data
end

task :populate_attributes => :environment do
  bad_listing_ids = []
  processed = 0
  BoatListing.find_in_batches do |group|
    populator = BoatListingAttributePopulator.new(group)
    populator.after_populate_callback = ->(listing) { listing.save! }
    populator.populate!
    bad_listing_ids += populator.bad_listings.map(&:id)
    puts "Processed #{processed += group.size}"
  end
  puts "There were #{bad_listing_ids.count} bad listings."
  puts "The bad listing ids are: #{bad_listing_ids.join(', ')}"

  # 129 bad ids
  # 64511, 64616, 67189, 68419, 68936, 70608, 74292, 74532, 75330,
  # 75451, 75460, 77126, 77215, 78590, 78968, 79357, 80675, 81196,
  # 81684, 86801, 86914, 86940, 86964, 87630, 88102, 89584, 89705,
  # 91754, 91755, 91756, 91757, 91762, 92617, 93530, 93532, 93613,
  # 94152, 94232, 95384, 95809, 96192, 96476, 96486, 96579, 98217,
  # 98335, 98951, 99141, 99261, 99307, 102179, 102645, 103122, 103510,
  # 104928, 106499, 107117, 107492, 108917, 108918, 109444, 109987,
  # 110209, 110218, 111142, 111210, 111211, 111212, 111367, 112104,
  # 113967, 113968, 114845, 115741, 115855, 116846, 116847, 116848,
  # 117515, 118136, 118434, 119755, 119756, 119760, 119761, 119763,
  # 119764, 119765, 119767, 119769, 120479, 121827, 122322, 122324,
  # 122325, 122326, 122327, 122328, 122329, 122330, 122331, 123511,
  # 123843, 124006, 124007, 124008, 124014, 124023, 124025, 124026,
  # 125257, 125436, 127081, 127082, 127083, 127084, 127085, 127086,
  # 127088, 127091, 127092, 127098, 127099, 127734, 127844, 127915,
  # 128268, 128535, 128699
end

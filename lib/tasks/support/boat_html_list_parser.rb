require 'nokogiri'

class BoatHtmlListParser
  DATA_ROOT = "/Users/ian/Development/code/ians_projects/sold_boats/data/batched_extended_data"
  FILE_FORMAT = "%{n}.data.html"

  class << self
    def populate_data(file_number = nil)
      if file_number
        populate_from_single_file(file_for(file_number))
      else
        populate_all
      end
    end

    def info_to_xml(id, doc)
      ul_parent = doc.xpath("//li[contains(text(), #{id})]").first.parent
      title = ul_parent.parent.xpath("h3").to_xml
      list = ul_parent.xpath("li").to_xml
      strip_line_noise(title + list)
    end

    def file_for n
      "#{DATA_ROOT}/#{FILE_FORMAT}" % {:n => n}
    end

    def strip_line_noise(str)
      str = str.gsub(/\n|\t/,'').gsub("&#xA0;",' ')
      # prevent invalid byte sequence
      # cf http://stackoverflow.com/questions/8710444/is-there-a-way-in-ruby-1-9-to-remove-invalid-byte-sequences-from-strings
      str.encode('UTF-16le', :invalid => :replace, :replace => ' ').encode('UTF-8')
    end

    private
    def populate_from_single_file(file)
      File.open(file) do |f|
        doc = doc_from_file(f)
        ids = doc.xpath("//a[@name]").map { |node| node.attributes["name"].value }
        BoatListing.where(:yw_id => ids).each do |listing|
          listing.update_attributes!(:yw_data => info_to_xml(listing.yw_id, doc))
        end
      end
    end

    def populate_all
      count = 0
      BoatListing.all.find_in_batches(:batch_size => 250) do |batch|
        File.open(file_for(count)) do |f|
          doc = doc_from_file(f)
          batch.each do |listing|
            yw_data = info_to_xml(listing.yw_id, doc)
            raise "invalid data for id: #{listing.yw_id}" unless valid_data?(yw_data, listing.yw_id)
            listing.update_attributes!(:yw_data => yw_data)
          end
        end
        puts "populated #{(count + 1) * 250} records"
        count += 1
      end
    rescue
      puts "=" * 50
      puts "Blew up on file #{file_for(count)}"
      puts "=" * 50
      raise $!
    end

    def doc_from_file(f)
      Nokogiri::HTML(f, nil,  'ISO-8859-1') do |config|
        config.nonet.noent
      end
    end

    def valid_data?(yw_data, yw_id)
      yw_data =~ /#{yw_id}/
    end
  end
end

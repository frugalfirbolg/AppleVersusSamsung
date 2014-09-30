# Download json from BestBuy API and generate seeds.rb
# Register for your API key at https://remix.mashery.com/member/register
# If you do not want to register an API key the app will simply use the pre-built seeds.rb
$api_key = 'p9b63psx9x7d45jnwd2cq8bw'
desc "Download data from BestBuy API and format JSON into seed.rb"
task :make_seed do
  require('net/http')
  require('json')
  seeds_file = File.open('db/seeds.rb', 'w')
  url_params = Hash['Samsung'=>'Galaxy*', 'Apple'=>'iPhone']
  url_params.each{|make, model|
    url = URI.parse("http://api.remix.bestbuy.com/v1/products(manufacturer=#{make}*&name=#{model}*&(classId=313%7CclassId=322%7CclassId=327%7CclassId=326))?show=name,shortDescription,largeImage,manufacturer,regularPrice,bestSellingRank,salesRankShortTerm,salesRankMediumTerm,salesRankLongTerm,classId&format=json&pageSize=100&apiKey=#{$api_key}&page=")
    for page_no in  1..2
      req = Net::HTTP::Get.new(url.to_s+page_no.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      products = JSON.parse(res.body)['products']
      #puts make + " page number " + page_no.to_s + ": " + products.length.to_s
      products.each{|product|
        # Normalize manufacturer property
        if /Apple/.match(product['manufacturer'])
          product['manufacturer'] = 'Apple'
        end
        if /Samsung/.match(product['manufacturer'])
          product['manufacturer'] = 'Samsung'
        end
        seeds_file.puts ("Phone.create(\
          name: '#{product['name']}',\
          shortDescription: '#{product['shortDescription']}',\
          largeImage: '#{product['largeImage']}',\
          manufacturer: '#{product['manufacturer']}',\
          regularPrice: '#{product['regularPrice']}',\
          bestSellingRank: '#{product['bestSellingRank']}',\
          salesRankShortTerm: '#{product['salesRankShortTerm']}',\
          salesRankMediumTerm: '#{product['salesRankMediumTerm']}',\
          salesRankLongTerm: '#{product['salesRankLongTerm']}',\
          classId: '#{product['classId']}')")
      }
    end
  }
  seeds_file.close
end

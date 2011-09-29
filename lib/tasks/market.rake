namespace :app do
  namespace :market do
    desc "Remove expired market listings"
    task :remove_expired_listings => :environment do
      puts "Removing expired market listings (#{MarketItem.expired.count})..."

      MarketItem.expired.find_each do |item|
        item.destroy
      end

      puts "Done"
    end
  end
end

namespace :app do
  desc "Cleanup old data"
  task :cleanup => %w{app:cleanup:fights app:cleanup:bank_operations app:cleanup:news app:cleanup:app_requests app:cleanup:gifts}

  namespace :cleanup do
    def remove_data(scope, batch = 100)
      first  = scope.first
      last   = scope.last

      if first and last
        total = scope.count

        puts "Deleting #{total} records (from #{first.id} to #{last.id})..."

        i = first.id

        while i < last.id
          scope.delete_all ["id BETWEEN ? AND ?", i, i + batch - 1]

          puts "Deleted records from #{i} to #{i + batch - 1} (max #{last.id}, total: #{total})"

          i += batch
        end

        puts "Done!"
      else
        puts "No records found"
      end
    end

    desc "Remove old fights"
    task :fights => :environment do
      time_limit = 1.month.ago

      old_fights = Fight.scoped(:conditions => ["created_at < ?", time_limit])

      puts "Removing old fights..."
      
      remove_data(old_fights)
    end

    desc "Remove old bank operations"
    task :bank_operations => :environment do
      time_limit = 1.month.ago

      old_operations = BankOperation.scoped(:conditions => ["created_at < ?", time_limit])

      puts "Removing old bank operations..."

      remove_data(old_operations)
    end

    desc "Remove old news"
    task :news => :environment do
      time_limit = 5.days.ago

      old_news = News::Base.scoped(:conditions => ["created_at < ?", time_limit])

      puts "Removing old news..."

      remove_data(old_news)
    end

    desc "Remove old application requests"
    task :app_requests => :environment do
      time_limit = 15.days.ago

      old_requests = AppRequest::Base.scoped(:conditions => ["created_at < ?", time_limit])

      puts "Removing old application requests..."

      remove_data(old_requests)
    end
  end
end
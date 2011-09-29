namespace :app do
  namespace :properties do
    desc 'Collect properties income'
    task :collect => :environment do
      characters = Character.find_in_batches(:batch_size => 100) do |group|
        group.each do |character|
          character.properties.auto_collectable.collect_money!
        end
      end
    end
  end
end

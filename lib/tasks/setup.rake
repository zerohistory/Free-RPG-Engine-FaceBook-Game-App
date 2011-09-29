namespace :app do
  desc 'Setup application'
  task :setup => [:environment, 'setup:assets', 'setup:stylesheets', 'setup:settings', 'setup:experience', 'setup:subscriptions']
  
  namespace :setup do
    desc "Setup application stylesheets"
    task :stylesheets => :environment do
      Asset.update_sass
      Skin.update_sass

      Sass::Plugin.update_stylesheets
    end

    desc "Re-import development assets. All existing assets will be destroyed!"
    task :assets, :destroy_old, :needs => :environment do |task, options|
      if options["destroy_old"] == "true" || ENV['DESTROY_ASSETS'] == 'true'
        puts "Destroying existing assets..."

        Asset.destroy_all
      end

      require Rails.root.join("db", "seeds", "assets")

      Rake::Task["app:setup:stylesheets"].execute
    end

    desc "Re-import settings"
    task :settings => :environment do
      require Rails.root.join("db", "seeds", "settings")
    end
    
    desc "Subscribe to real-time updates"
    task :subscriptions => :environment do
      puts 'Setting up real-time update subscriptions...'
      
      client = Mogli::AppClient.create_and_authenticate_as_application(Facebooker2.app_id, Facebooker2.secret)
      client.application_id = Facebooker2.app_id
      
      client.subscribe_to_model(Mogli::User, 
        :fields => [:first_name, :last_name, :email, :gender, :timezone, :third_party_id, :locale],
        :callback_url => Facebooker2.callback_url + '/users/subscribe',
        :verify_token => Digest::MD5.hexdigest(Facebooker2.secret)
      )
      
      puts 'Done!'
    end
    
    desc "Generate experience table for levels"
    task :experience, :regenerate, :needs => :environment do |task, options|
      if Character::Levels::EXPERIENCE.empty? || options['regenerate'] == 'true'
        puts 'Generating experience table for levels...'
        
        experience = [0]
      
        1000.times do |i|
          experience[i + 1] = ((experience[i].to_i * 1.02 + (i + 1) * 10).round / 10.0).round * 10
        end
        
        File.open(Character::Levels::DATA_FILE, 'w+') do |file|
          file.puts(*experience)
        end
        
        puts 'Done!'
      end
    end
  end
end

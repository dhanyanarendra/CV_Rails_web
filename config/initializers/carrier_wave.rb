CarrierWave.configure do |config|


  if Rails.env.test?
    CarrierWave.configure do |config|
      config.storage = :file
    end
  else
    CarrierWave.configure do |config|
      config.storage = :fog
    end
  end


  unless Rails.env.test?
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['ACCESS_KEY_ID'],                        # required
      :aws_secret_access_key  => ENV['SECRET_ACCESS_KEY'],                        # required
      :region                 => 'us-west-2',                  # optional, defaults to 'us-east-1'
    }

    config.fog_directory  =  ConfigCenter::Default.fog_directory                     # required
    config.fog_public     = false
    config.asset_host     = ConfigCenter::Default.host                        # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end

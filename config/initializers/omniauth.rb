require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,  'mshsD0jpgcYwwOEcTW5ZTA', 'V6KTqllY5jS392pj4FNFCb5EiOM8DaFzVwr9cS54XQ'
end

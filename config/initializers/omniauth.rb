Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '183019445158455', '290325efa1d29c347870afdc98287106', :scope => 'email,user_birthday,publish_stream', :display => 'popup'
end
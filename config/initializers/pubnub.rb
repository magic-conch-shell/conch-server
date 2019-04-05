require 'pubnub'
$pubnub = Pubnub.new(
  subscribe_key: ENV['PUBLISH_KEY'],
  publish_key: ENV['SUBSCRIBE_KEY']
)

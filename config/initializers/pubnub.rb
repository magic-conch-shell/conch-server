require 'pubnub'
$pubnub = Pubnub.new(
  publish_key: ENV['PN_PUBLISH_KEY'],
  subscribe_key: ENV['PN_SUBSCRIBE_KEY']
)

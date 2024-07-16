require "google/cloud/pubsub"

namespace :pubsub do
  desc 'Cloud Pub/Sub Test'
  task test: :environment do
    pubsub = Google::Cloud::PubSub.new(
      project_id: ENV.fetch('PROJECT_ID'),
      credentials: Rails.root.join("tmp/service-account.json")
    )

    # Retrieve a topic
    topic = pubsub.topic "my-topic"

    # Publish a new message
    msg = topic.publish "new-message"

    # Retrieve a subscription
    sub = pubsub.subscription "my-sub"

    # Create a subscriber to listen for available messages
    # By default, this block will be called on 8 concurrent threads.
    # This can be changed with the :threads option
    subscriber = sub.listen do |received_message|
      # process message
      puts "Data: #{received_message.message.data}, published at #{received_message.message.published_at}"
      received_message.acknowledge!
    end

    # Handle exceptions from listener
    subscriber.on_error do |exception|
      puts "Exception: #{exception.class} #{exception.message}"
    end

    # Gracefully shut down the subscriber on program exit, blocking until
    # all received messages have been processed or 10 seconds have passed
    at_exit do
      subscriber.stop!(10)
    end

    # Start background threads that will call the block passed to listen.
    subscriber.start

    # Block, letting processing threads continue in the background
    sleep
  end
end

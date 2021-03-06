ActionMailer::Base.class_eval do

  # Deliver +mail+ using the :cache delivery method.
  # This is called by the ActionMailer#deliver! method.
  def perform_delivery_cache(mail)
    deliveries = self.class.cached_deliveries
    deliveries << mail

    File.open(ActionMailerCacheDelivery.deliveries_cache_path,'w') do |f|
      Marshal.dump(deliveries, f)
    end
  end

  # Return the list of cached deliveries, or an empty list if there are none.
  # This is called by email_spec.
  def self.cached_deliveries
    File.open(ActionMailerCacheDelivery.deliveries_cache_path,'r') do |f|
      Marshal.load(f)
    end
  end

  # Clear the delivery cache of all emails.
  # This is called by email_spec before each scenario.
  def self.clear_cache
    deliveries.clear

    # Marshal the empty list of deliveries
    File.open(ActionMailerCacheDelivery.deliveries_cache_path, 'w') do |f|
      Marshal.dump(deliveries, f)
    end
  end

end

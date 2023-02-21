require 'eu_central_bank'
require 'money'

desc "Fetch the exchange rates from the European Central Bank"

namespace :money do
  task :fetch_exchange_rates do
    puts "Fetching exchange rates from the European Central Bank"
    eu_bank = EuCentralBank.new
    Money.default_bank = eu_bank
    
    # Cache file
    cache = "/tmp/eu_bank_rates.xml"

    # reads the rates from the specified location
    eu_bank.update_rates(cache)

    if !eu_bank.rates_updated_at || eu_bank.rates_updated_at < Time.now - 1.days
      puts "Rates are stale, fetching new rates"
      eu_bank.save_rates(cache)
      eu_bank.update_rates(cache)
      puts "Rates updated"
    else
      puts "Rates are fresh, not fetching new rates"
    end
  end
end
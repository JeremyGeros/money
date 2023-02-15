# Cache file
require 'eu_central_bank'
require 'money'

eu_bank = EuCentralBank.new
Money.default_bank = eu_bank

cache = "/tmp/eu_bank_rates.xml"

if !eu_bank.rates_updated_at || eu_bank.rates_updated_at < Time.now - 1.days
  eu_bank.save_rates(cache)
  eu_bank.update_rates(cache)
end
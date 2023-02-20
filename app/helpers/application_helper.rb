module ApplicationHelper
  include Pagy::Frontend

  def class_if(condition, klass)
    condition ? klass : ''
  end

  def nav_active(controller)
    class_if(params[:controller] == controller, 'nav-active')
  end

  def show_recap_highlight?
    DateTime.now.month == 12 || DateTime.now.month < 3
  end

  def pretty_date_display(date)
    return '' unless date

    if (date.year == DateTime.now.year || date.year == DateTime.now.year - 1)
      date.strftime('%b %d')
    else
      date.strftime('%b %d, %Y')
    end
  end

  def display_account_balance(account)
    return '' unless account

    "#{number_to_currency(account.balance)} #{account.currency.upcase}"
  end

  def display_amount(amount)
    return '' unless amount

    number_to_currency(amount)
  end

  def display_amount_colored(amount, currency = '', color_override = nil)
    return '' unless amount

    content_tag :span, class: color_override || (amount < 0 ? 'text-red-500' : 'text-green-500') do
      number_to_currency(amount) + " #{currency}"
    end
  end

  def display_spend_category(spend)
    return '' unless spend

    icons = {
      'food' => '🍔',
      'transportation' => '🚗',
      'entertainment' => '🎮',
      'health' => '🏥',
      'shopping' => '🛍️',
      'utilities' => '🔌',
      'income' => '💰',
      'online_services' => '🌐',
      'baby' => '👶',
      'cafe' => '☕',
      'restaurant' => '🍽️',
      'supermarket' => '🛒',
      'gas' => '⛽',
      'pharmacy' => '💊',
      'clothing' => '👕',
      'electronics' => '📱',
      'home' => '🏠',
      'taxis' => '🚕',
      'movies' => '🎥',
      'water' => '💧',
      'power' => '⚡',
      'internet' => '🌐',
      'salary' => '💰',
      'payment' => '💳',
      'books' => '📚',
      'tv' => '📺',
      'web_services' => '🌐',
      'rent' => '🏠',
      'dairy' => '🥛',
      'insurance' => '🏥',
      'transfer' => '🔄',
      'other' => '🤷',
      'interest' => '💰',
      'taxes' => '📃',
      'travel' => '✈️',
      'delivery_food' => '🍕',
    }

    if spend.icon.attached?
      image_tag spend.icon, class: 'w-4 h-4 inline-block'
    else
      icons[spend.category.to_s.downcase] || spend.category.humanize
    end
  end

  def account_display(account)
    content_tag :div, class: 'flex items-center' do
      account.logo.attached? ? image_tag(account.logo, class: 'w-4 mr-1') : ''
      +
      link_to(account.name, account_path(account), target: "_top")
    end
  end

end

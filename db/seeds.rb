require 'securerandom'

puts "🌱 Seeding database..."

# Clear existing data in correct order (respecting foreign key constraints)
puts "Cleaning up existing data..."
[
  StampTransaction,
  UserStampCard,
  Stamp,
  OfferRedemption,
  Offer,
  AuditLog,
  RedeemTransaction,
  EarnTransaction,
  ShopPointsWallet,
  UserPointsBalance,
  ShopAdmin,
  MallAdmin,
  Qr,
  Transaction,
  Receipt,
  Shop,
  Category,
  Mall,
  User,
  Tier
].each do |model|
  model.delete_all if model.table_exists?
end

# 1. Create Tiers
puts "Creating tiers..."
bronze = Tier.create!(
  tier_name: 'Bronze',
  points_required: 0,
  benefits: {
    multiplier: 1.0,
    perks: ['Basic rewards', 'Birthday bonus']
  }
)

silver = Tier.create!(
  tier_name: 'Silver',
  points_required: 1000,
  benefits: {
    multiplier: 1.2,
    perks: ['Priority support', 'Exclusive offers', '20% bonus points']
  }
)

gold = Tier.create!(
  tier_name: 'Gold',
  points_required: 5000,
  benefits: {
    multiplier: 1.5,
    perks: ['VIP lounge access', 'Personal shopper', '50% bonus points']
  }
)

platinum = Tier.create!(
  tier_name: 'Platinum',
  points_required: 10000,
  benefits: {
    multiplier: 2.0,
    perks: ['Concierge service', 'Free valet parking', '100% bonus points', 'Early sale access']
  }
)
puts "✓ Created #{Tier.count} tiers"

# 2. Create Users
puts "Creating users..."
users = []
user_names = [
  ['Ahmed', 'Hassan'], ['Fatima', 'Ali'], ['Omar', 'Khalil'], ['Layla', 'Mansour'],
  ['Khaled', 'Nasser'], ['Sara', 'Ibrahim'], ['Mohammed', 'Yousef'], ['Noor', 'Saleh'],
  ['Youssef', 'Farhan'], ['Hana', 'Rashid'], ['Zaid', 'Mahmoud'], ['Amira', 'Karim'],
  ['Hassan', 'Samir'], ['Lina', 'Tariq'], ['Rami', 'Adel'], ['Dina', 'Fadi'],
  ['Tariq', 'Majed'], ['Rana', 'Walid'], ['Sami', 'Nabil'], ['Maya', 'Jamal']
]

user_names.each_with_index do |(first, last), i|
  tier = case i
         when 0..14 then bronze  # Most users are bronze
         when 15..17 then silver # Some silver
         when 18 then gold       # Few gold
         when 19 then platinum   # One platinum
         end

  user = User.create!(
    firstname: first,
    lastname: last,
    phone: "+96277#{7000000 + i}",
    email: "#{first.downcase}.#{last.downcase}@example.com",
    password_hash: '$2a$12$K9Z8VQ8X0YvMXqK0sHvZqeKJH8YZ0qYvMXqK0sHvZqeKJH8YZ0qYv', # bcrypt hash of 'password123'
    gender: ['Male', 'Female'].sample,
    tier: tier
  )
  users << user

  # Create user points balance
  points = case tier.tier_name
           when 'Bronze' then rand(0..800)
           when 'Silver' then rand(1000..4500)
           when 'Gold' then rand(5000..9500)
           when 'Platinum' then rand(10000..15000)
           end

  UserPointsBalance.create!(
    user_id: user.id,
    total_points: points,
    lifetime_points: points + rand(0..2000)
  )
end
puts "✓ Created #{User.count} users with points balances"

# 3. Create Malls
puts "Creating malls..."
malls = [
  Mall.create!(mall_name: 'City Center Mall', location: 'Downtown Amman, Amman, Jordan'),
  Mall.create!(mall_name: 'Taj Mall', location: 'Abdoun, Amman, Jordan'),
  Mall.create!(mall_name: 'Mecca Mall', location: 'Mecca Street, Amman, Jordan'),
  Mall.create!(mall_name: 'Galleria Mall', location: 'Queen Rania Street, Amman, Jordan')
]
puts "✓ Created #{Mall.count} malls"

# 4. Create Categories
puts "Creating categories..."
categories = {
  fashion: Category.create!(category_name: 'Fashion & Apparel', description: 'Clothing, shoes, and accessories'),
  food: Category.create!(category_name: 'Food & Dining', description: 'Restaurants, cafes, and food courts'),
  electronics: Category.create!(category_name: 'Electronics', description: 'Phones, computers, and gadgets'),
  beauty: Category.create!(category_name: 'Beauty & Cosmetics', description: 'Makeup, skincare, and fragrances'),
  home: Category.create!(category_name: 'Home & Furniture', description: 'Home decor and furniture'),
  sports: Category.create!(category_name: 'Sports & Fitness', description: 'Sportswear and equipment'),
  entertainment: Category.create!(category_name: 'Entertainment', description: 'Cinema, gaming, and leisure')
}
puts "✓ Created #{Category.count} categories"

# 5. Create Shops
puts "Creating shops..."
shops = []
shop_data = [
  { name: 'Zara', category: :fashion, mall_idx: 0 },
  { name: 'H&M', category: :fashion, mall_idx: 1 },
  { name: 'Mango', category: :fashion, mall_idx: 2 },
  { name: 'Nike Store', category: :sports, mall_idx: 0 },
  { name: 'Adidas Originals', category: :sports, mall_idx: 1 },
  { name: 'Starbucks', category: :food, mall_idx: 0 },
  { name: 'McDonalds', category: :food, mall_idx: 1 },
  { name: 'Pizza Hut', category: :food, mall_idx: 2 },
  { name: 'KFC', category: :food, mall_idx: 3 },
  { name: 'Subway', category: :food, mall_idx: 0 },
  { name: 'Apple Store', category: :electronics, mall_idx: 1 },
  { name: 'Samsung Store', category: :electronics, mall_idx: 2 },
  { name: 'Sephora', category: :beauty, mall_idx: 0 },
  { name: 'MAC Cosmetics', category: :beauty, mall_idx: 1 },
  { name: 'IKEA', category: :home, mall_idx: 2 },
  { name: 'Home Center', category: :home, mall_idx: 3 },
  { name: 'VOX Cinemas', category: :entertainment, mall_idx: 0 },
  { name: 'Grand Cinemas', category: :entertainment, mall_idx: 1 }
]

shop_data.each do |data|
  shop = Shop.create!(
    mall: malls[data[:mall_idx]],
    name: data[:name],
    category: categories[data[:category]],
    is_active: true
  )
  shops << shop

  # Create shop points wallet
  ShopPointsWallet.create!(
    shop_id: shop.id,
    points_received: rand(1000..50000)
  )
end
puts "✓ Created #{Shop.count} shops with points wallets"

# 6. Create Mall Admins
puts "Creating mall admins..."
malls.each_with_index do |mall, i|
  MallAdmin.create!(
    mall: mall,
    name: "#{mall.mall_name} Manager",
    email: "admin#{i+1}@#{mall.mall_name.downcase.gsub(' ', '')}.com",
    phone: "+96277900#{1000 + i}",
    password_hash: '$2a$12$K9Z8VQ8X0YvMXqK0sHvZqeKJH8YZ0qYvMXqK0sHvZqeKJH8YZ0qYv'
  )
end
puts "✓ Created #{MallAdmin.count} mall admins"

# 7. Create Shop Admins
puts "Creating shop admins..."
shops.each_with_index do |shop, i|
  ShopAdmin.create!(
    shop: shop,
    name: "#{shop.name} Manager",
    email: "manager#{i+1}@#{shop.name.downcase.gsub(/[^a-z0-9]/, '')}.com",
    phone: "+96278000#{1000 + i}",
    password_hash: '$2a$12$K9Z8VQ8X0YvMXqK0sHvZqeKJH8YZ0qYvMXqK0sHvZqeKJH8YZ0qYv',
    is_active: true
  )
end
puts "✓ Created #{ShopAdmin.count} shop admins"

# 8. Create Receipts and Transactions
puts "Creating receipts and transactions..."
receipt_ids = []
50.times do |i|
  user = users.sample
  shop = shops.sample
  amount = rand(10..500)
  created_time = rand(60.days.ago..Time.now)

  receipt = Receipt.create!(
    shop: shop,
    user: user,
    amount: amount,
    receipt_path: "receipts/2024/#{created_time.strftime('%Y%m')}/RCP-#{SecureRandom.hex(8)}.pdf",
    receipt_details: {
      receipt_number: "RCP-#{sprintf('%06d', i + 1)}",
      items: [
        { name: 'Item 1', price: (amount * 0.6).round(2), quantity: 1 },
        { name: 'Item 2', price: (amount * 0.4).round(2), quantity: 1 }
      ],
      subtotal: amount,
      tax: (amount * 0.16).round(2),
      total: (amount * 1.16).round(2),
      payment_method: ['Cash', 'Credit Card', 'Debit Card'].sample
    }
  )
  receipt_ids << receipt.id

  Transaction.create!(
    user: user,
    shop: shop,
    receipt: receipt,
    amount: amount,
    created_at: created_time
  )
end
puts "✓ Created #{Receipt.count} receipts and #{Transaction.count} transactions"

# 9. Create Earn Transactions
puts "Creating earn transactions..."
40.times do
  user = users.sample
  shop = shops.sample
  purchase_amount = rand(20.0..300.0).round(2)
  points_earned = (purchase_amount * 0.1).round
  created_time = rand(45.days.ago..Time.now)

  EarnTransaction.create!(
    user: user,
    shop: shop,
    purchase_amount: purchase_amount,
    points_earned: points_earned,
    transaction_ref: "TXN-#{SecureRandom.hex(6).upcase}",
    created_at: created_time
  )

  # Update user points balance
  balance = UserPointsBalance.find_by(user_id: user.id)
  if balance
    balance.update!(
      total_points: balance.total_points + points_earned,
      lifetime_points: balance.lifetime_points + points_earned
    )
  end

  # Update shop wallet
  wallet = ShopPointsWallet.find_by(shop_id: shop.id)
  wallet.update!(points_received: wallet.points_received + points_earned) if wallet
end
puts "✓ Created #{EarnTransaction.count} earn transactions"

# 10. Create Redeem Transactions
puts "Creating redeem transactions..."
20.times do
  user = users.sample
  shop = shops.sample
  points_used = [50, 100, 150, 200, 300, 500].sample

  # Check if user has enough points
  balance = UserPointsBalance.find_by(user_id: user.id)
  next unless balance && balance.total_points >= points_used

  status = ['pending', 'verified', 'completed'].sample
  created_time = rand(30.days.ago..Time.now)
  completed_time = status == 'completed' ? created_time + rand(1..60).minutes : nil

  RedeemTransaction.create!(
    user: user,
    shop: shop,
    points_used: points_used,
    discount_value: (points_used * 0.05).round(2),
    verification_code: sprintf('%06d', rand(100000..999999)),
    status: status,
    created_at: created_time,
    completed_at: completed_time
  )

  # Deduct points if completed
  if status == 'completed'
    balance.update!(total_points: [balance.total_points - points_used, 0].max)
  end
end
puts "✓ Created #{RedeemTransaction.count} redeem transactions"

# 11. Create Offers
puts "Creating offers..."
offers = []
shops.sample(12).each_with_index do |shop, i|
  offer = Offer.create!(
    shop: shop,
    name: "#{shop.name} #{['Summer', 'Winter', 'Spring', 'Holiday', 'Weekend', 'Flash'].sample} Special",
    description: "Exclusive #{['discount', 'offer', 'deal'].sample} for loyalty members",
    reward_type: ['discount', 'points', 'free_item'].sample,
    reward_value: {
      value: [10, 15, 20, 25, 30, 50].sample,
      description: ['% off', 'bonus points', 'free item'].sample
    },
    redemptions_count: rand(5..100),
    active: i < 8, # First 8 are active
    start_date: 2.months.ago,
    end_date: 2.months.from_now
  )
  offers << offer
end
puts "✓ Created #{Offer.count} offers"

# 12. Create Offer Redemptions
puts "Creating offer redemptions..."
offers.select(&:active).each do |offer|
  rand(3..8).times do
    user = users.sample
    created_time = rand(offer.start_date..Time.now)

    OfferRedemption.create!(
      user: user,
      offer: offer,
      shop: offer.shop,
      redemption_ref: receipt_ids.sample,
      created_at: created_time
    )
  end
end
puts "✓ Created #{OfferRedemption.count} offer redemptions"

# 13. Create Stamps
puts "Creating stamps..."
stamps = []
shops.sample(10).each do |shop|
  stamp = Stamp.create!(
    shop: shop,
    name: "#{shop.name} Loyalty Card",
    description: "Collect stamps with every purchase and earn rewards",
    stamps_required: [5, 8, 10, 12].sample,
    reward_type: ['free_item', 'discount'].sample,
    reward_value: {
      description: ["Free #{shop.name} item", "20% off next purchase", "Buy 1 Get 1 Free"].sample
    },
    active: true,
    expiration_limit: 6.months.from_now,
    stamps_limit: 50,
    start_date: 2.months.ago,
    end_date: 6.months.from_now
  )
  stamps << stamp
end
puts "✓ Created #{Stamp.count} stamps"

# 14. Create User Stamp Cards
puts "Creating user stamp cards..."
user_stamp_cards = []
stamps.each do |stamp|
  users.sample(rand(5..12)).each do |user|
    stamps_counter = rand(0..stamp.stamps_required + 2)
    is_completed = stamps_counter >= stamp.stamps_required
    last_trans = rand(30.days.ago..Time.now)

    card = UserStampCard.create!(
      user: user,
      stamp: stamp,
      stamps_counter: [stamps_counter, stamp.stamps_required].min,
      is_completed: is_completed,
      last_transaction: last_trans,
      completed_at: is_completed ? last_trans : nil,
      created_at: rand(45.days.ago..30.days.ago)
    )
    user_stamp_cards << card
  end
end
puts "✓ Created #{UserStampCard.count} user stamp cards"

# 15. Create Stamp Transactions
puts "Creating stamp transactions..."
user_stamp_cards.each do |card|
  # Activation transaction
  StampTransaction.create!(
    user: card.user,
    shop: card.stamp.shop,
    stamp: card.stamp,
    type: 'activation',
    stamps_count: 0,
    created_at: card.created_at
  )

  # Add stamp transactions
  card.stamps_counter.times do |i|
    StampTransaction.create!(
      user: card.user,
      shop: card.stamp.shop,
      stamp: card.stamp,
      type: 'stamp',
      stamps_count: 1,
      created_at: card.created_at + (i + 1).days
    )
  end

  # Redemption transaction if completed
  if card.is_completed
    StampTransaction.create!(
      user: card.user,
      shop: card.stamp.shop,
      stamp: card.stamp,
      type: 'redeem_reward',
      stamps_count: -card.stamp.stamps_required,
      redemption_ref: receipt_ids.sample,
      created_at: card.completed_at || card.last_transaction
    )
  end
end
puts "✓ Created #{StampTransaction.count} stamp transactions"

# 16. Create Audit Logs
puts "Creating audit logs..."
40.times do
  user = users.sample
  shop = shops.sample
  action = ['earn', 'redeem', 'admin_adjust', 'tier_change'].sample

  AuditLog.create!(
    user: user,
    shop: action == 'tier_change' ? nil : shop,
    admin_id: ShopAdmin.pluck(:id).sample,
    admin_type: 'shop_admin',
    action_type: action,
    points: action == 'admin_adjust' ? rand(-200..200) : rand(10..500),
    metadata: {
      reason: ['Purchase', 'Redemption', 'Manual adjustment', 'Tier upgrade'].sample,
      notes: 'Processed successfully'
    },
    created_at: rand(60.days.ago..Time.now)
  )
end
puts "✓ Created #{AuditLog.count} audit logs"

# 17. Create QR codes
puts "Creating QR codes..."
users.sample(15).each do |user|
  Qr.create!(
    user: user,
    shop: shops.sample
  )
end
puts "✓ Created #{Qr.count} QR codes"

puts "\n" + "="*60
puts "✅ Seeding completed successfully!"
puts "="*60
puts "\n📊 Database Summary:"
puts "-" * 60
puts "  Tiers:                    #{Tier.count}"
puts "  Users:                    #{User.count}"
puts "  User Points Balances:     #{UserPointsBalance.count}"
puts "  Malls:                    #{Mall.count}"
puts "  Categories:               #{Category.count}"
puts "  Shops:                    #{Shop.count}"
puts "  Shop Points Wallets:      #{ShopPointsWallet.count}"
puts "  Mall Admins:              #{MallAdmin.count}"
puts "  Shop Admins:              #{ShopAdmin.count}"
puts "  Receipts:                 #{Receipt.count}"
puts "  Transactions:             #{Transaction.count}"
puts "  Earn Transactions:        #{EarnTransaction.count}"
puts "  Redeem Transactions:      #{RedeemTransaction.count}"
puts "  Offers:                   #{Offer.count}"
puts "  Offer Redemptions:        #{OfferRedemption.count}"
puts "  Stamps:                   #{Stamp.count}"
puts "  User Stamp Cards:         #{UserStampCard.count}"
puts "  Stamp Transactions:       #{StampTransaction.count}"
puts "  Audit Logs:               #{AuditLog.count}"
puts "  QR Codes:                 #{Qr.count}"
puts "-" * 60
puts "\n🔐 `Login` Information:"
puts "  User Email:      ahmed.hassan@example.com"
puts "  User Password:   password123"
puts "  Admin Email:     admin1@citycentermall.com"
puts "  Admin Password:  password123"
puts "="*60
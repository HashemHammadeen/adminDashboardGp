
# Script to generate new credentials for Mall Admin and Shop Admin
puts "Generating new credentials..."

begin
  ActiveRecord::Base.transaction do
    # Mall Admin
    mall = Mall.first || Mall.create!(mall_name: "Default Mall", location: "Default Location")
    mall_admin_email = "new.mall.admin.#{SecureRandom.hex(4)}@example.com"
    mall_admin_password = "password123"
    
    puts "Creating Mall Admin for mall: #{mall.mall_name}"
    
    ma = MallAdmin.new(
      name: "New Mall Admin",
      email: mall_admin_email,
      phone: "+96279#{rand(1000000..9999999)}",
      password: mall_admin_password,
      password_confirmation: mall_admin_password,
      mall: mall
    )
    ma.save!

    puts "✅ Generated New Mall Admin:"
    puts "   Email: #{mall_admin_email}"
    puts "   Password: #{mall_admin_password}"
    puts "   Mall: #{mall.mall_name}"

    # Shop Admin
    category = Category.first || Category.create!(category_name: "Default")
    shop = Shop.first || Shop.create!(name: "Default Shop", category: category, mall: mall)
    shop_admin_email = "new.shop.admin.#{SecureRandom.hex(4)}@example.com"
    shop_admin_password = "password123"
    
    puts "Creating Shop Admin for shop: #{shop.name}"

    sa = ShopAdmin.new(
      name: "New Shop Admin",
      email: shop_admin_email,
      phone: "+96279#{rand(1000000..9999999)}",
      password: shop_admin_password,
      password_confirmation: shop_admin_password,
      shop: shop
    )
    sa.save!

    puts "✅ Generated New Shop Admin:"
    puts "   Email: #{shop_admin_email}"
    puts "   Password: #{shop_admin_password}"
    puts "   Shop: #{shop.name}"
  end
rescue => e
  puts "❌ Error creating admins: #{e.message}"
  if e.respond_to?(:record) && e.record
    puts "Validation errors: #{e.record.errors.full_messages}"
  end
  puts e.backtrace.first(5)
end

User.create!(name: "TMO",
  email: "anhnt.tmo@gmail.com",
  phone: "0974626374",
  password: "123456",
  password_confirmation: "123456",
  role: 1)

Room.create!(name: "101",
  description: "adsadsadasdasdsad",
  price: 100010,
  types: :Single
)

Room.create!(name: "102",
  description: "fgdfgfdgdgfgdfg",
  price: 232323,
  types: :Double
)

Room.create!(name: "103",
  description: "teumiloo wifi",
  price: 412412312,
  types: :King
)

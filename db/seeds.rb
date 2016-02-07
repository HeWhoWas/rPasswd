# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Setting.create(key: "IPA_SERVER", value: nil)
Setting.create(key: "IPA_PRINCIPAL", value: nil)
Setting.create(key: "IPA_KEYTAB_PATH", value: nil)
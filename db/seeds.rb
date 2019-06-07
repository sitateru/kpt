# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
Issue.create(title: 'みんなの進捗がリモートのためみえにく', body: '進捗が見えないとリモートワークだと不安', status: :problem)
Issue.create(title: '朝会をする', body: '朝会にて機能の進捗を確認', status: :keep)
Issue.create(title: 'ディスプレイをつかってみる', body: 'ディスプレイにて作業効率が上がるか確かめる', status: :try)

User.create(name: 'tyamada', email: 'tyamada@example.com')
User.create(name: 'hsuzuki', email: 'hsuzuki@example.com')

Assignment.create(issue_id: 1, user_id: 1)
Assignment.create(issue_id: 2, user_id: 1)
Assignment.create(issue_id: 2, user_id: 2)

Group.create(name: 'developers').user_ids = [1, 2]
Group.create(name: 'operators').user_ids = [1]
Group.create(name: 'testers')

User.create({name: "rick"})
User.create({name: "john"})
User.create({name: "paul"})

Post.create({user_id: 1, content:"2nd post"})
Post.create({user_id: 3, content:"this is a post"})
Post.create({user_id: 5, content:"this is a great"})
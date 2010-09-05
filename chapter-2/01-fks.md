Comment.belongs_to Post

p = Post.new
c = Comment.new(:post => p)
p.destroy
 => true
c.reload; c.valid?
 => false
# but it's in the DB!

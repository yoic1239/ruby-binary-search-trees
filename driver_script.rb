require './lib/tree'

def print_all_orders(tree)
  print 'Level Order: '
  tree.level_order do |node|
    print "#{node.data} "
  end
  puts ''

  print 'Preorder: '
  tree.preorder do |node|
    print "#{node.data} "
  end
  puts ''

  print 'Postorder: '
  tree.postorder do |node|
    print "#{node.data} "
  end
  puts ''

  print 'Inorder: '
  tree.inorder do |node|
    print "#{node.data} "
  end
  puts ''
end

# Driver script
bst = Tree.new(Array.new(15) { rand(1..100) })
bst.pretty_print
puts bst.balanced? ? 'The tree is balanced.' : 'The tree is unbalanced.'

print_all_orders(bst)
puts ''

bst.insert(rand(101..150))
bst.insert(rand(101..150))
bst.insert(rand(101..150))
bst.pretty_print
puts bst.balanced? ? 'The tree is balanced.' : 'The tree is unbalanced.'
puts ''

bst.rebalance
bst.pretty_print
puts bst.balanced? ? 'The tree is balanced.' : 'The tree is unbalanced.'
print_all_orders(bst)

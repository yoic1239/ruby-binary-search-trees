require './lib/node'

class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    sorted = array.sort.uniq
    return if sorted == []

    node_idx = sorted.length.odd? ? (sorted.length - 1) / 2 : sorted.length / 2

    node = Node.new(sorted[node_idx])
    if node_idx > 0
      node.left_children = build_tree(sorted[0...node_idx])
      node.right_children = build_tree(sorted[node_idx + 1..])
    end
    node
  end

  def insert(value)
    return if find(value)

    curr_node = @root
    insert_node = Node.new(value)
    loop do
      next_node = insert_node < curr_node ? curr_node.left_children : curr_node.right_children
      break unless next_node

      curr_node = next_node
    end

    insert_node < curr_node ? curr_node.left_children = insert_node : curr_node.right_children = insert_node
  end

  def delete(value)
    return unless find(value)

    del_node = find(value)
    if del_node.left_children && del_node.right_children
      delete_both_children_node(value, del_node)
    elsif del_node.left_children || del_node.right_children
      delete_single_child_node(value, del_node)
    else
      delete_leaf_node(value, del_node)
    end
  end

  def delete_leaf_node(value, del_node)
    parent_node = find_parent(value)

    if del_node < parent_node
      parent_node.left_children = nil
    else
      parent_node.right_children = nil
    end
  end

  def delete_single_child_node(value, del_node)
    parent_node = find_parent(value)
    child_node = del_node.left_children || del_node.right_children

    if del_node < parent_node
      parent_node.left_children = child_node
    else
      parent_node.right_children = child_node
    end
  end

  def delete_both_children_node(value, del_node)
    next_biggest_node = find_next_biggest(value)
    next_biggest_parent_node = find_parent(next_biggest_node.data)
    del_node.data = next_biggest_node.data
    next_biggest_parent_node.left_children = nil
  end

  def find(value)
    curr_node = @root
    loop do
      return curr_node if curr_node.data == value

      curr_node = value < curr_node.data ? curr_node.left_children : curr_node.right_children
      break unless curr_node
    end
  end

  def find_parent(value)
    curr_node = @root
    parent_node = nil
    loop do
      return parent_node if curr_node.data == value

      parent_node = curr_node
      curr_node = value < curr_node.data ? curr_node.left_children : curr_node.right_children
      break unless curr_node
    end
  end

  def find_next_biggest(value)
    curr_node = find(value).right_children
    curr_node = curr_node.left_children while curr_node.left_children
    curr_node
  end

  def level_order
    queue = [@root]
    traverse = []

    while queue[0]
      yield queue[0] if block_given?
      queue << queue[0].left_children if queue[0].left_children
      queue << queue[0].right_children if queue[0].right_children
      traverse << queue.shift
    end

    traverse
  end

  def inorder(node = @root, &block)
    traverse = []
    traverse += inorder(node.left_children) if node.left_children
    traverse << node
    traverse += inorder(node.right_children) if node.right_children

    if node == @root && block_given?
      traverse.each(&block)
    else
      traverse
    end
  end

  def preorder(node = @root, &block)
    traverse = []
    traverse << node
    traverse += preorder(node.left_children) if node.left_children
    traverse += preorder(node.right_children) if node.right_children

    if node == @root && block_given?
      traverse.each(&block)
    else
      traverse
    end
  end

  def postorder(node = @root, &block)
    traverse = []
    traverse += postorder(node.left_children) if node.left_children
    traverse += postorder(node.right_children) if node.right_children
    traverse << node

    if node == @root && block_given?
      traverse.each(&block)
    else
      traverse
    end
  end

  def height(node)
    curr_node = node
    num_of_edges = 0

    left_height = node.left_children ? 1 + height(node.left_children) : 0
    right_height = node.right_children ? 1 + height(node.right_children) : 0

    num_of_edges + [left_height, right_height].max
  end

  def depth(node)
    num_of_edges = 0
    curr_node = node

    while curr_node != @root
      curr_node = find_parent(curr_node.data)
      num_of_edges += 1
    end
    num_of_edges
  end

  def balanced?
    level_order do |node|
      if node.left_children && node.right_children
        return false if height(node.left_children) - height(node.right_children) > 1
      elsif node.left_children || node.right_children
        return false if height(node) > 1
      end
    end
    true
  end

  def rebalance
    array = inorder.map(&:data)
    @root = build_tree(array)
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end
end

class Node
  attr_accessor :data, :left_children, :right_children

  include Comparable
  def initialize(data)
    @data = data
    @left_children = nil
    @right_children = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

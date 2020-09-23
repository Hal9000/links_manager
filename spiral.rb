def show
  @arr.each {|sub| printf "%3s "*@cols + "\n", *sub }
  puts
  gets
end

@arr = []
@rows = 29
@mrow = @rows/2
@cols = 7
@mcol = @cols/2

@empty = "--"

@rows.times  { @arr << Array.new(@cols, @empty) }

show
puts

# start at center
@r, @c = @mrow, @mcol

# dirs = D L U R  r+1 c-1 r-1 c+1

def down(n=1)
  n.times do
    @r, @c = @r+1, @c
    store
  end
end

def left(n=1)
  n.times do
    @r, @c = @r, @c-1
    store
  end
end

def up(n=1)
  n.times do
    @r, @c = @r-1, @c
    store
  end
end

def right(n=1)
  n.times do
    @r, @c = @r, @c+1
    store
  end
end

def store(n=1)
  @num += 1
  @arr[@r][@c] = @num
end

dirs = [:down, :left, :up, :right]

directions = dirs.cycle

@num = 0
store

down  1
left  1
up    2
right 2
show

down  3
left  3
up    4
right 4
show

down  5
left  5
up    6
right 6
show

down  7
left  7
up    8
right 8
show

down  9
left  9
up    10
right 10
show

down  11
left  11
up    12
right 12
show


#!/usr/bin/ruby

# Check if distribution of number i is consistent in the sudoku.
# If >1 occurence of i is found in a line, column or sector, return 1.
# Otherwise, return nil.

class Sudoku

  def getGrid
    # Set up grid
    @grid = Array.new(9)
    @grid.collect! { Array.new(9) }
    9.times do |y|
      9.times do |x|
        @grid[x][y] = [1,2,3,4,5,6,7,8,9]
      end
    end

    puts "Enter the sudoku:"

    # Get sudoku
    @n_unsolved = 0
    9.times do |y|
      line = gets

      while line.length < 9
        puts "Not enough chars. Please re-enter\a:"
        line = gets
      end

      9.times do |x|
        num = line[x].chr.to_i
        if num > 0 and num < 10
          @grid[x][y] = [num]
        else
          @n_unsolved += 1
        end

      end
    end
  end
  def printOut
    #mode = 'debug'
    mode = 'normal'
    9.times do |y|
      9.times do |x|
        if mode == 'debug'
          printf("%12s", @grid[x][y].to_s)
        else
          arr = @grid[x][y]
          if arr.length == 1
            print arr[0].to_s + ' '
          else
            print '. '
          end
        end
      end
      puts
    end
    puts
  end

  def setToSinglePossibility(n, x, y)
    #puts x.to_s + ',' + y.to_s + ':  ' + @grid[x][y].inspect
    nRemoved = @grid[x][y].length - 1
    if (nRemoved > 0)
      @n_unsolved -= 1
      @n_reductions_last_run += nRemoved
      @grid[x][y] = [n]

      puts "Set #{x.to_s},#{y.to_s} to #{n.to_s}, notifying... #{@n_unsolved.to_s} remaining!"
    end

    notifyRelations(n, x, y)
  end

  def removePossibility(n, x, y)
    r = @grid[x][y].delete(n)
    if r
      @n_reductions_last_run += 1
      if @grid[x][y].length == 1
        val = @grid[x][y][0]
        puts "Removing #{n.to_s} from #{x.to_s},#{y.to_s} leaves just #{val.to_s}"
        @n_unsolved -= 1
        puts "Set #{x.to_s},#{y.to_s} to #{val.to_s}, notifying... #{@n_unsolved.to_s} remaining!"
        notifyRelations(val, x, y)
      end
    end
  end

  def notifyRelations(val, x, y)
    # Notify row
    9.times { |i| removePossibility(val, i, y) if i != x }

    # Notify column
    9.times { |j| removePossibility(val, x, j) if j != y }

    # Notify block
    3.times do |i|
      a = i + x/3*3

      3.times do |j|
        b = j + y/3*3
        removePossibility(val, a, b) if a != x or b != y
      end

    end

  end

  def method1
    puts "\nStarting method 1: removal of those solved from relations."
    printOut

    @n_reductions_last_run = 1

    while @n_reductions_last_run > 0 and @n_unsolved > 0
      @n_reductions_last_run = 0
      9.times do |x|
        9.times do |y|
          notifyRelations(@grid[x][y][0], x, y) if @grid[x][y].length == 1
        end
      end
    end

    return @n_reductions_last_run

  end

  def method2
    puts "\nStarting method 2: set numbers occurring only once in row/col/block as solved."
    printOut

    @n_reductions_last_run = 1

    lastXWhereNWas = 0
    lastYWhereNWas = 0

    while @n_reductions_last_run > 0 and @n_unsolved > 0
      @n_reductions_last_run = 0

      9.times do |x|
        1.upto(9) do |n|
          count = 0
          9.times do |y|
            if @grid[x][y].include?(n)
              count += 1
              lastXWhereNWas = x
              lastYWhereNWas = y
            end
          end
          if count == 1
            setToSinglePossibility(n, lastXWhereNWas, lastYWhereNWas)
          end
        end
      end

      9.times do |y|
        1.upto(9) do |n|
          count = 0
          9.times do |x|
            if @grid[x][y].include?(n)
              count += 1
              lastXWhereNWas = x
              lastYWhereNWas = y
            end
          end
          if count == 1
            setToSinglePossibility(n, lastXWhereNWas, lastYWhereNWas)
          end
        end
      end

      3.times do |x|
        x *= 3
        3.times do |y|
          y *= 3

          1.upto(9) do |n|
            count = 0

            3.times do |a|
              i = a + x
              3.times do |b|
                j = b + y
                if @grid[i][j].include?(n)
                  count += 1
                  lastXWhereNWas = i
                  lastYWhereNWas = j
                end
              end
            end

            setToSinglePossibility(n, lastXWhereNWas, lastYWhereNWas) if count == 1
          end
        end
      end

    end

    return @n_reductions_last_run

  end

  def method3
    puts "\nStarting method 3: remove those in row/col only in one block from the rest of the block."
    printOut

    @n_reductions_last_run = 1
    while @n_reductions_last_run > 0 and @n_unsolved > 0
      @n_reductions_last_run = 0

      9.times do |x|
        1.upto(9) do |n|
          blocksFoundIn = []
          blockRow = -1
          9.times do |y|
            if @grid[x][y].include?(n)
              blockRow = y/3*3
              blocksFoundIn.push(blockRow) unless blocksFoundIn.include?(blockRow) or @grid[x][y].length == 1
            end
          end

          if blocksFoundIn.length == 1
            blockCol = x/3*3
            puts "In col #{x.to_s}, #{n.to_s} only in block #{blockCol.to_s},#{blockRow.to_s}, removing from rest of block..."

            3.times do |a|
              i = blockCol + a
              3.times do |b|
                j = blockRow + b
                removePossibility(n, i, j) if i != x
              end
            end
          end
        end
      end

      9.times do |y|
        1.upto(9) do |n|
          blocksFoundIn = []
          blockCol = -1
          9.times do |x|
            if @grid[x][y].include?(n)
              blockCol = x/3*3
              blocksFoundIn.push(blockCol) unless blocksFoundIn.include?(blockCol) or @grid[x][y].length == 1
            end
          end

          if blocksFoundIn.length == 1
            blockRow = y/3*3
            puts "In row #{y.to_s}, #{n.to_s} only in block #{blockCol.to_s},#{blockRow.to_s}, removing from rest of block..."

            3.times do |a|
              i = blockCol + a
              3.times do |b|
                j = blockRow + b
                removePossibility(n, i, j) if j != y
              end
            end
          end
        end
      end

    end

    return @n_reductions_last_run

  end

  def solve
    puts "#{@n_unsolved} empty, trying to solve by logic alone...\n"

    while @n_unsolved > 0 and (method1 != 0 or method2 != 0 or method3 != 0)
      # la la la
    end

    if (@n_unsolved > 0)
      puts "\nCould not solve."
    else
      puts "\nSolved!"
    end

    printOut

  end

end

s = Sudoku.new
s.getGrid
s.solve

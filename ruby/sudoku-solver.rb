class Sudoku
		attr_accessor :solutionCount

		def initialize
				# create @sudoku, the array of 81 Unit obects
				@sudoku = Array.new(9)
				@sudoku.collect! { Array.new(9) }
				9.times do |y|
						9.times do |x|
								@sudoku[x][y] = Unit.new
						end
				end

				@unsolved = Array.new				# create an array for unsolved Units
				@solutionCount = 0
		end

		# Set each supplied number as appropriate Unit's value
		def get
				puts "\nEnter puzzle:"
				9.times do |y|
					line = gets
					while line.length < 9
							puts "Not enough chars; please re-enter line:"
							line = gets
					end

					9.times do |x|
							if line[x] < 58 and line[x] > 48
									number = line[x,1].to_i
									@sudoku[x][y].value = number
							end
					end
				end
		end

		# Add the sudoku's empty units to the array: @unsolved
		def getUnsolved
				9.times do |y|
						9.times do |x|
								@unsolved << @sudoku[x][y] if @sudoku[x][y].value == nil
						end
				end
		end

		# Print out the current state of the sudoku
		def put
				9.times do |y|
						9.times do |x|
								number = @sudoku[x][y].value
								if number == nil
										number = @sudoku[x][y].testValue
										if number == nil
												print '. '
										else
												print number.to_s + ' '
										end
								else
										print number.to_s + ' '
								end
						end
						puts
				end
		end

		def solved!
				puts "Sudoku solved!"
				put; puts
				@solutionCount += 1
				exit
		end

		# Check if distribution of number i is consistent in the sudoku.
		# If >1 occurence of i is found in a line, column or sector, return 1.
		# Otherwise, return nil.
		def inconsistent?(i)
				# check rows
				9.times do |y|
						count = 0
						9.times do |x|
								count += 1 if @sudoku[x][y].value == i or @sudoku[x][y].testValue == i
						end
						return 1 if count > 1
				end

				# check columns
				9.times do |x|
						count = 0
						9.times do |y|
								count += 1 if @sudoku[x][y].value == i or @sudoku[x][y].testValue == i
						end
						return 1 if count > 1
				end

				# check sectors
				0.step(6,3) do |y|
						0.step(6,3) do |x|
								count = 0
								3.times do |b|
										3.times do |a|
												count += 1 if @sudoku[x+a][y+b].value == i or @sudoku[x+a][y+b].testValue == i
										end
								end
								return 1 if count > 1
						end
				end

				return nil
		end

		# Recursively try numbers in the empty Units.
		# Will exit after finding 1st solution.
		def solve(x)
				solved! if @unsolved.empty?
				9.times do |i|
						@unsolved[x].increment
						#print "In unsolved location #{x+1}, trying #{@unsolved[x].testValue}... "
						if inconsistent?(@unsolved[x].testValue)
								#puts "inconsistent"
						else
								#puts "ok"
								if @unsolved[x+1]
										#put; puts
										solve(x+1)
								else
										solved!
								end
						end
				end
				@unsolved[x].reset
		end

end

# A Unit's value, if one is given, is stored in @value.
# For Units with no given value, @value is nil.
# @testValue is the current (hypothetical) value of the Unit, for solving purposes.
class Unit
		attr_accessor :value, :testValue

		def initialize
				@value = nil
				@testValue = nil
		end

		def increment
				if @testValue
						@testValue += 1
				else
						@testValue = 1
				end
		end

		def reset
				@testValue = nil
		end
end


thesudoku = Sudoku.new
thesudoku.get
thesudoku.getUnsolved
thesudoku.put; puts

thesudoku.solve(0)

puts thesudoku.solutionCount.to_s + " solutions found!"
### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 64a5dd61-e012-4998-a9d7-ab453b51e173
begin
	using Random
	using StatsBase
end

# ╔═╡ 98d81590-425b-427a-8b6c-61aaefa99a67
function is_solved(puzzle::Matrix{Int64})
	return puzzle == [
		1 2 3;
		8 0 4;
		7 6 5;
	]
end

# ╔═╡ 7d4e9df2-901a-4ea2-aa40-a552e6b41f11
function get_moves(puzzle::Matrix{Int64})
	zero_pos = findfirst(x-> x == 0, puzzle)
	
	moves = []
	if zero_pos[2] - 1 >= 1
		push!(moves, "left")
	end
	if zero_pos[2] + 1 <= 3
		push!(moves, "right")
	end
	if zero_pos[1] - 1 >= 1
		push!(moves, "up")
	end
	if zero_pos[1] + 1 <= 3
		push!(moves, "down")
	end
	return moves
end

# ╔═╡ faf15672-33ad-48e2-968f-8ac775c71373
function _move(puzzle::Matrix{Int64}, pos::CartesianIndex{2})
	swap = puzzle[pos]
	zero_pos = findfirst(x-> x == 0, puzzle)
	
	temp = deepcopy(puzzle)
	temp[pos] = 0
	temp[zero_pos] = swap
	
	return temp
end

# ╔═╡ bf522eb9-9347-4eac-a22e-f45032bbbb94
function do_move(puzzle::Matrix{Int64}, move::String)
	zero_pos = findfirst(x-> x == 0, puzzle)
	
	if move == "left"
        temp = _move(puzzle, CartesianIndex(zero_pos[1], zero_pos[2]-1))
	elseif move == "right"
		temp = _move(puzzle, CartesianIndex(zero_pos[1], zero_pos[2]+1))
	elseif move == "up"
		temp = _move(puzzle, CartesianIndex(zero_pos[1]-1, zero_pos[2]))
	elseif move == "down"
		temp = _move(puzzle, CartesianIndex(zero_pos[1]+1, zero_pos[2]))
	end
	
	return temp
end

# ╔═╡ a659d363-53bb-49d2-a06f-78c4e4784813
function evaluate(puzzle::Matrix{Int64})
	soln = [
		1 2 3;
		8 0 4;
		7 6 5;
	]
	
	# calculate dist of each number from its final location
	dist = 0
	for i in 1:3
		for j in 1:3
			if puzzle[i, j] != soln[i, j]
				dist += 1
			end
		end
	end
	
	return dist
end

# ╔═╡ cc54f97e-df94-4f30-9e91-6cd1287703d2
function opposite(move::String)
	if move == "up"
		return "down"
	elseif move == "down"
		return "up"
	elseif move == "left"
        return "right"
	elseif move == "right"
		return "left"
	end
	
	return "none"
end

# ╔═╡ e914b630-fb9e-45af-aaa5-e220adec736a
function sim_annealing(
		puzzle::Matrix{Int64};
		initial_temp = 1000,
		final_temp = 1,
		filtering=false)
	
	curr_temp = initial_temp
	moves_taken = []
	
	while !is_solved(puzzle)
		moves = get_moves(puzzle)
		
		while true
			# do not allow opposite of last move 
			# ex: (if last move was up, don't allow down)
			if filtering && !isempty(moves_taken)
				last_move = opposite(last(moves_taken))
				filter!(x -> x != last_move, moves)
			end
			
			move = sample(moves)
			cost = evaluate(puzzle) - evaluate(do_move(puzzle, move))
			
			# accept better solution
			if cost >= 0
				puzzle = do_move(puzzle, move)
				push!(moves_taken, move)
				break
			# accept with probability e^(-cost/temp)
			elseif rand() < exp(-cost/curr_temp)
				puzzle = do_move(puzzle, move)
				push!(moves_taken, move)
				break
			end
		end
		
		curr_temp -= 1
		if (curr_temp <= final_temp)
			break
		end
	end
	
	return puzzle, moves_taken
end

# ╔═╡ f619fd7f-1c80-4766-817a-9231e4a75608
function solve_attempt(temp::Int64; filtering::Bool=false)
	goal = [
		1 2 3;
		8 0 4;
		7 6 5;
	]
	
	puzzle = shuffle(goal)
	
	result_puzzle, moves_taken = sim_annealing(
		puzzle, initial_temp=temp, filtering=filtering)
	
	return is_solved(result_puzzle), Dict([
		"Initial" => puzzle,
		"Goal" => goal,
		"Result" => result_puzzle,
		"Moves Taken" => length(moves_taken)
	])
end

# ╔═╡ 6f530188-5777-48f4-8c92-8e3a69b0ee69
solve_attempt(100)

# ╔═╡ 5d18542d-cbb4-4cbf-a97d-ff2fff1afa2d
function solve_8puzzle(temp::Int64; filtering::Bool=false)
	solved, result = solve_attempt(temp, filtering=filtering)
	attempts = 1
	while !solved
		solved, result = solve_attempt(temp, filtering=filtering)
		attempts += 1
	end
	
	return solved, attempts, result
end

# ╔═╡ 01de7563-0c54-466e-9d14-1b55a7125aad
solve_8puzzle(1000)

# ╔═╡ fb26af38-db44-4d5b-a04c-c2609ce1c54d
function experiment(trials::Int64, temp::Int64; filtering::Bool=false)
	result = []
	
	while length(result) < trials
		solved, attempts, _ = solve_8puzzle(temp, filtering=filtering)
		push!(result, attempts)
	end
	
	return Dict([
		"Average" => sum(result)/length(result),
		"Maximum" => maximum(result),
		"Minimum" => minimum(result)
	])
end

# ╔═╡ 7b783e72-e398-4122-903c-d9041a0fb155
experiment(25, 1000)

# ╔═╡ 1cec7226-a25d-4dad-bd74-338e1c4f7b3f
experiment(25, 1000, filtering=true)

# ╔═╡ Cell order:
# ╠═64a5dd61-e012-4998-a9d7-ab453b51e173
# ╠═98d81590-425b-427a-8b6c-61aaefa99a67
# ╠═7d4e9df2-901a-4ea2-aa40-a552e6b41f11
# ╠═bf522eb9-9347-4eac-a22e-f45032bbbb94
# ╠═faf15672-33ad-48e2-968f-8ac775c71373
# ╠═a659d363-53bb-49d2-a06f-78c4e4784813
# ╠═cc54f97e-df94-4f30-9e91-6cd1287703d2
# ╠═e914b630-fb9e-45af-aaa5-e220adec736a
# ╠═f619fd7f-1c80-4766-817a-9231e4a75608
# ╠═6f530188-5777-48f4-8c92-8e3a69b0ee69
# ╠═5d18542d-cbb4-4cbf-a97d-ff2fff1afa2d
# ╠═01de7563-0c54-466e-9d14-1b55a7125aad
# ╠═fb26af38-db44-4d5b-a04c-c2609ce1c54d
# ╠═7b783e72-e398-4122-903c-d9041a0fb155
# ╠═1cec7226-a25d-4dad-bd74-338e1c4f7b3f

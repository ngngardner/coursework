
import random
import time

import matplotlib.pyplot as plt
import numpy as np

from agent import Agent
from puzzle import Puzzle

# random starting location in 3x3 grid
data = np.ones(25, dtype=int)
pos = random.randint(0, 24)
data[pos] = 0
data = data.reshape(5, 5)

# initial state and goal state
init = Puzzle(data)
goal = Puzzle(np.ones(25, dtype=int).reshape(5, 5))
goal.data[2, 2] = 0

print('starting state:')
print(init.data)
print('goal state:')
print(goal.data)

# create agent
a = Agent(init, goal)
step = 0
moves = []

print(a.solved())

# reach goal state incrementally
while not a.solved():
    step += 1
    action = a.step()
    print(f'Step {step}: {action}')
    print(a.curr_state.data)
    moves.append(action)

print('Solved Puzzle')
print(moves)

# animate moves
input('Press Enter to start animation...')
img = np.zeros((80, 80, 3), np.uint8)
pos = init.get_position(0)
img[
    16 * pos[0]:16*(pos[0]+1) - 1,
    16 * pos[1]:16*(pos[1]+1) - 1,
    :
] = 255
plt.figure()
plt.imshow(img)
plt.savefig('output.png')
time.sleep(0.5)

for i in range(len(moves)):
    print(f'Step {i+1}: {moves[i]}')
    init.move(moves[i])
    img = np.zeros((80, 80, 3), np.uint8)
    pos = init.get_position(0)
    img[
        16 * pos[0]:16*(pos[0]+1) - 1,
        16 * pos[1]:16*(pos[1]+1) - 1,
        :
    ] = 255
    plt.clf()
    plt.imshow(img)
    plt.savefig('output.png')
    time.sleep(0.5)

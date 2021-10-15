
from copy import deepcopy

import numpy as np

from puzzle import Puzzle


class Agent:
    def __init__(self, init: Puzzle, goal: Puzzle) -> None:
        self.table = {}
        self.goal = goal
        self.init = init
        self.reset()

    def reset(self) -> None:
        self.curr_state = deepcopy(self.init)
        self.history = []

    def solved(self) -> bool:
        return np.linalg.norm(
            np.array(self.curr_state.get_position(0)) -
            np.array(self.goal.get_position(0))) == 0

    def step(self) -> str:
        actions = self.curr_state.get_moves()

        # calculate the difference between the goal state and
        # the next state for each action
        costs = []
        for action in actions:
            temp = deepcopy(self.curr_state)
            temp.move(action)
            cost = np.linalg.norm(
                np.array(temp.get_position(0)) -
                np.array(self.goal.get_position(0))
            )
            costs.append(cost)

        selected_action = actions[costs.index(min(costs))]
        self.curr_state.move(selected_action)
        return selected_action

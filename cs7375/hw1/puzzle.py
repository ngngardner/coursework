
import numpy as np


class Puzzle:
    def __init__(self, data: np.array) -> None:
        self.data = data
        self.rows, self.cols = self.data.shape

    def get_value(self, pos: tuple) -> int:
        assert len(pos) == 2

        return self.data[pos[0], pos[1]]

    def get_position(self, value: int) -> list:
        pos = np.where(self.data == value)
        assert len(pos) == 2

        row = pos[0][0]
        col = pos[1][0]
        return [row, col]

    def _move(self, pos: tuple) -> None:
        temp = self.get_value(pos)
        zero_pos = self.get_position(0)

        self.data[pos[0], pos[1]] = 0
        self.data[zero_pos[0], zero_pos[1]] = temp

    def move(self, action: str) -> None:
        zero_pos = self.get_position(0)
        if action == 'left':
            self._move((zero_pos[0], zero_pos[1]-1))
        elif action == 'right':
            self._move((zero_pos[0], zero_pos[1]+1))
        elif action == 'up':
            self._move((zero_pos[0]-1, zero_pos[1]))
        elif action == 'down':
            self._move((zero_pos[0]+1, zero_pos[1]))

    def get_moves(self) -> list:
        zero_pos = self.get_position(0)
        moves = []
        if zero_pos[1] - 1 >= 0:
            moves.append('left')
        if zero_pos[1]+1 <= self.cols - 1:
            moves.append('right')
        if zero_pos[0] - 1 >= 0:
            moves.append('up')
        if zero_pos[0]+1 <= self.rows - 1:
            moves.append('down')
        return moves

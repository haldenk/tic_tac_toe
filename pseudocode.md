person in db (x, or o), will hold list of indexes

handle event function for move

board, use loop to make cells, the index will determine the coordinates. index 1 is (1, 1), index 2 is (1, 2), index 3 is (1, 3), index 4 is (2, 1), etc...

winning combinations:
horizintal:
(1, 2, 3)
(4, 5, 6)
(7, 8, 9)
vertical:
(1, 4, 7)
(2, 5, 8)
(3, 6, 9)
diagonal:
(1, 5, 9)
(3, 5, 7)

when the user clicks a square, the corresponding index of the tile will be saved to db

all winning combinations stored, if a user's coordinates have all winning coordinates, they win.

check_winner() will be called every time the move function is called

Mount function ----> board, current_player: x, winner: nil

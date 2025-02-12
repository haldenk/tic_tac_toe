defmodule TicTacToe.GameContextTest do
  # testing utilities
  use TicTacToe.DataCase
  # convenience aliases
  alias TicTacToe.GameContext
  alias TicTacToe.Game
  alias TicTacToe.Repo


  test "get_or_create_game returns an existing game if present" do
    # Insert a game into the database with some values
    game = %Game{x_moves: [1], o_moves: [2], x_wins: 1, o_wins: 0} |> Repo.insert!()
    # Fetch the game, when get or create game is called, it should return ^game^
    assert GameContext.get_or_create_game() == game
  end


  test "get_or_create_game returns a new struct if no game exists" do
    # Ensure database is empty
    Repo.delete_all(Game)
    # Fetch the game
    game = GameContext.get_or_create_game()
    # all cols in the db should be empty when a new game is created
    assert game.x_moves == []
    assert game.o_moves == []
    assert game.x_wins == 0
    assert game.o_wins == 0
    assert game.__struct__ == Game
  end

  test "Records an X move correctly" do
    # create a new, empty game
    game = %Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    # the index of the tile clicked by x, to be passed into the record move function
    index = 3
    #  call the record move function, passing in the empty game, and the index
    {:ok, updated_game} = GameContext.record_move(game, index, "X")
    # we expect the x moves to incliude 3, and the o moves to be empty
    assert updated_game.x_moves == [3]
    assert updated_game.o_moves == []
  end

  test "Records an O move correctly" do
    # create a new, empty game
    game = %Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    # the index of the tile clicked by o, to be passed into the record move function
    index = 3
    # call the record move function, passing the empty game and index
    {:ok, updated_game} = GameContext.record_move(game, index, "O")
    # we expect the o moves to include 3, and the x moves to be empty
    assert updated_game.x_moves == []
    assert updated_game.o_moves == [3]
  end

  test "check_winner detects an X win of (0, 1, 2) and updates the game" do
    # Create a game where X has a winning combination
    game = %Game{x_moves: [0, 1, 2], o_moves: [3, 4], x_wins: 1, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that X is recognized as the winner
    assert {:winner, "X", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins + 1
    assert updated_game.o_wins == game.o_wins
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an X win of (3, 4, 5) and updates the game" do
    # Create a game where X has a winning combination
    game = %Game{x_moves: [3, 4, 5], o_moves: [3, 4], x_wins: 3, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that X is recognized as the winner
    assert {:winner, "X", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins + 1
    assert updated_game.o_wins == game.o_wins
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an X win of (6, 7, 8) and updates the game" do
    # Create a game where X has a winning combination
    game = %Game{x_moves: [6, 7, 8], o_moves: [3, 4], x_wins: 2, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that X is recognized as the winner
    assert {:winner, "X", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins + 1
    assert updated_game.o_wins == game.o_wins
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an X win of (0, 4, 8) and updates the game" do
    # Create a game where X has a winning combination
    game = %Game{x_moves: [0, 4, 8], o_moves: [3, 4], x_wins: 2, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that X is recognized as the winner
    assert {:winner, "X", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins + 1
    assert updated_game.o_wins == game.o_wins
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an O win of (0, 3, 6) and updates the game" do
    # Create a game where O has a winning combination
    game = %Game{o_moves: [0, 3, 6], x_moves: [3, 5], x_wins: 1, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that O is recognized as the winner
    assert {:winner, "O", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins
    assert updated_game.o_wins == game.o_wins + 1
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an O win of (1, 4, 7) and updates the game" do
    # Create a game where O has a winning combination
    game = %Game{o_moves: [1, 4, 7], x_moves: [6, 5], x_wins: 1, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that O is recognized as the winner
    assert {:winner, "O", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins
    assert updated_game.o_wins == game.o_wins + 1
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an O win of (2, 5, 8) and updates the game" do
    # Create a game where O has a winning combination
    game = %Game{o_moves: [2, 5, 8], x_moves: [6, 0], x_wins: 1, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that O is recognized as the winner
    assert {:winner, "O", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins
    assert updated_game.o_wins == game.o_wins + 1
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end

  test "check_winner detects an O win of (2, 4, 6) and updates the game" do
    # Create a game where O has a winning combination
    game = %Game{o_moves: [2, 4, 6], x_moves: [5, 0], x_wins: 1, o_wins: 0}

    # Call check_winner
    result = GameContext.check_winner(game)

    # Assert that O is recognized as the winner
    assert {:winner, "O", {:ok, updated_game}} = result
    assert updated_game.x_wins == game.x_wins
    assert updated_game.o_wins == game.o_wins + 1
    assert updated_game.x_moves == []
    assert updated_game.o_moves == []
  end


end

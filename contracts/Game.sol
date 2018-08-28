pragma solidity ^0.4.23;

import "./GameLibrary.sol";

contract Game {
    using GameLibrary for *;

    // Size of ships
    bytes public ships;

    // Determining the maximum umber of moves each of the players get
    uint public maxRounds;
  
  //Board is a square, maximum board size is 16 (= sqrt(256)).
    uint public boardSize;

    enum GameStatus {
      NeedOpponent,
      Playing,
      RevealMoves,
      RevealBoard,
      Over
    }

    enum PlayerStatus {
      Ready,
      Playing,
      RevealedMoves,
      RevealedBoard
    }

    event RevealMoves(address player);
    event JoinGame(address player);
    event RevealBoard(address player);


    struct Player {
        // Player's board
        bytes board;
        
        uint moves;
        
        // hash of player's board (should be obtained via calculateBoardHash)
        bytes32 boardHash;
        
         // number of hits player has scored against opponent
        uint hits;
        
        // player state
        PlayerStatus state;
    }

    // players
    mapping (address => Player) public players;
    address public player1;
    address public player2;

    // current game state
    GameStatus public state;

  //Revealing board when ready 
    modifier canRevealMoves () {
        require(state == GameStatus.Playing || state == GameStatus.RevealMoves);
        
        // //double checking to see if the player has revealed their moves
        require(players[msg.sender].state == PlayerStatus.Playing);
        _;
    }


    //seeing if I can reval the board
    modifier canRevealBoard () {
        require(state == GameStatus.RevealMoves || state == GameStatus.RevealBoard);
        require(players[msg.sender].state == PlayerStatus.RevealedMoves);
        _;
    }


  //Joining game (seeing if the player can)
    modifier canJoin () {
        require(state == GameStatus.NeedOpponent);
        require(address(0) == player2);
        require(msg.sender != player1);
        _;
    }


  //Initialize the game.
    constructor (bytes ships_, uint boardSize_, uint maxRounds_, bytes32 boardHash_) public {
        require(1 <= ships_.length);
        require(2 <= boardSize_ && 16 >= boardSize_);
        require(1 <= maxRounds_ && (boardSize_ * boardSize_) >= maxRounds_);
        
        // game setup below
        ships = ships_;
        maxRounds = maxRounds_;
        boardSize = boardSize_;
        
        // player setup below
        player1 = msg.sender;
        players[player1].boardHash = boardHash_;
        players[player1].state = PlayerStatus.Playing;
        
        // game state
        state = GameStatus.NeedOpponent;
    }


  //Joining the game
    function join(bytes32 boardHash_)
      public
      canJoin()
    {
        // adding a player
        player2 = msg.sender;
        players[player2].boardHash = boardHash_;
        players[player2].state = PlayerStatus.Playing;
        
        // game status
        state = GameStatus.Playing;
        
        // log
        emit JoinGame(player2);
    }


  //Revealing the moves
    function revealMoves(uint moves_)
        public
        canRevealMoves()
    {

        require(GameLibrary.countBits(moves_) <= maxRounds);

        // update player
        players[msg.sender].moves = moves_;
        players[msg.sender].state = PlayerStatus.RevealedMoves;
        state = GameStatus.RevealMoves;

        address opponent = (msg.sender == player1) ? player2 : player1;

        if (players[opponent].state == PlayerStatus.RevealedMoves) {
            state = GameStatus.RevealBoard;
    }

        // log
        emit RevealMoves(msg.sender);
    }


  //Reveaing the board
    function revealBoard(bytes board_)
        public
        canRevealBoard()
    {
        require(players[msg.sender].boardHash == GameLibrary.calculateBoardHash(ships, boardSize, board_));

        // updating player
        players[msg.sender].board = board_;
        players[msg.sender].state = PlayerStatus.RevealedBoard;

        address opponent = (player1 == msg.sender) ? player2 : player1;

        // calculating the opponent's hits
        calculateHits(players[msg.sender], players[opponent]);

        if (players[opponent].state == PlayerStatus.RevealedBoard) {
            state = GameStatus.Over;
    }

      // log
        emit RevealBoard(msg.sender);
    }


  //Calculating the number of hits on the ships
    function calculateHits(Player storage revealer_, Player storage mover_) internal {
        // now let's count the hits for the mover and check board validity in one go
        mover_.hits = 0;

        for (uint ship = 0; ships.length > ship; ship += 1) {
            
            // extract ship info
            uint index = 3 * ship;
            
            uint x = uint(revealer_.board[index]);
           
            uint y = uint(revealer_.board[index + 1]);
            
            bool isVertical = (0 < uint(revealer_.board[index + 2]));
            
            uint shipSize = uint(ships[ship]);

            // now let's see if there are hits
            while (0 < shipSize) {
                
                // hit?
                if (0 != (GameLibrary.calculateMove(boardSize, x, y) & mover_.moves)) {
                    mover_.hits += 1;
                }
                
                // move to next part of ship
                if (isVertical) {
                    x += 1;
                } else {
                    y += 1;
                }
                
                shipSize -= 1;
            }
        }
    }


   //Reverting fallback 
    function() public {
        revert();
    }

  // Helper functions
  // Getting the metadata
    function getMetadata() public view returns (
    bytes _ships,
    uint _boardSize,
    uint _maxRounds,
    GameStatus _state,
    address _player1,
    address _player2
    ) {
        _ships = ships;
        _maxRounds = maxRounds;
        _boardSize = boardSize;
        _state = state;
        _player1 = player1;
        _player2 = player2;
    }

}
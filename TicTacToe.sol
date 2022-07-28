// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "hardhat/console.sol";

contract TicTacToe {
    //adresses of players and whose turn is to do action
    address internal playerX;
    address internal playerO;
    address internal whosAction;
    //matrix of the play field
    uint[9] internal playField;

    //modifier to check that exactly two players are playing and to check that players are switched
    modifier playersChecker {
        require(msg.sender == playerX || msg.sender == playerO, "Only players!");
        require(msg.sender == whosAction, "Wait your turn!");
        _;
    }
    

    //modifier to check game over
    modifier notGameOver {
        require(!gameOver(), "Game Over!");
        _;
    }

    //modifier to check for empty cells
    modifier zoneChecker(uint position) {
        require(playField[position] == 0, "Choose another position!");
        _;
    }

    //smart contract constructor, called at the beginning
    constructor(address _playerO) {
        playerX = msg.sender;
        playerO = _playerO;
        whosAction = playerX;
    }

    //sets the sign of the X and O, on the field
    function setAction(uint position) external notGameOver playersChecker zoneChecker(position) {
        uint8[2] memory playersSigns = [1,2];
        uint signInArray = 0;

        if(whosAction == playerX) {
            whosAction = playerO;
        } else {
            signInArray++;
            whosAction = playerX;
        }

        playField[position] = playersSigns[signInArray];
    }


    //shows game field
    function showField() external view returns(string memory, string memory, string memory) {
        bytes memory field = new bytes(9);
        bytes1[3] memory symbols = [bytes1("_"), bytes1("X"), bytes1("O")];

        for(uint i = 0; i < field.length; ++i) {
            field[i] = symbols[playField[i]];  
        }

        string memory one = string(bytes.concat(field[0],field[1],field[2]));
        one = string.concat(one, "\n");
        string memory two = string(bytes.concat(field[3],field[4],field[5]));
        two = string.concat(two, "\n");
        string memory three = string(bytes.concat(field[6],field[7],field[8]));
        three = string.concat(three, "\n");

        return(one, two, three);
    }

    //checks if the game is over
    function gameOver() public view returns(bool) {
        //check rows
        for(uint i = 0; i < playField.length - 3; i+=3) {
            if(winDefinition(i,i+1,i+2))
                return true;
        }

        //check columns
        for(uint i = 0; i < playField.length - 6; i++) {
            if(winDefinition(i,i+3,i+6))
                return true;
        }

        //check diagonals
        if(winDefinition(0, 4, 8))
            return true;
        if(winDefinition(2, 4, 6))
            return true;

        return false;
    }
    
    //ways to win
    function winDefinition(uint positionOne, uint positionTwo, uint positionThree) internal view returns(bool) {
        return playField[positionOne] != 0 && playField[positionOne] == playField[positionTwo] && playField[positionTwo] == playField[positionThree];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract TicTacToe {
    //adresses of players and whose turn is to do action
    address playerX;
    address playerO;
    address whosAction;
    //matrix of play zone
    uint[9] public playZone;
    //flag to check if players have changed
    bool playerSwitched = false;

    //modifier to check that exactly two players are playing
    modifier playersSelected() {
        require(msg.sender == playerX || msg.sender == playerO, "Only players can call this function");
        _;
    }

    constructor(address _playerO) {
        playerX = msg.sender;
        playerO = _playerO;
        whosAction = playerX;
        console.log(whosAction);
    }

    function setAction(uint position) external playersSelected() {
        require(msg.sender == whosAction, "You cannot do this action until your opponent has chosen an action!");
        console.log(whosAction);
        if(whosAction == playerX) {
            zoneChecker(position, 2);
            playZone[position] = 1;
            whosAction = playerO;
            console.log(whosAction);
        } else {
            zoneChecker(position, 1);
            playZone[position] = 2;
            whosAction = playerX;
            console.log(whosAction);
        }
    }


    function showZone() public view returns(string memory, string memory, string memory) {
        bytes memory zone = new bytes(9);
        bytes1[3] memory symbols = [bytes1("_"), bytes1("X"), bytes1("O")];

        for(uint i = 0; i < zone.length; ++i) {
            zone[i] = symbols[playZone[i]];  
        }
        string memory one = string(bytes.concat(zone[0],zone[1],zone[2]));
        one = string.concat(one, "\n");
        string memory two = string(bytes.concat(zone[3],zone[4],zone[5]));
        two = string.concat(two, "\n");
        string memory three = string(bytes.concat(zone[6],zone[7],zone[8]));
        three = string.concat(three, "\n");

        return(one, two, three);
    }

    function zoneChecker(uint position, uint chosenZones) internal view {
        require(playZone[position] != chosenZones, "Choose another position because your opponent chose it!");
    }
}

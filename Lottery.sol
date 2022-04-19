//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    // State variables
    address payable[] public players;
    address public manager;
    uint public lotteryId;

    // Mapping to create a record of all the winners
    mapping (uint => address payable) public lotteryHistory;


    constructor(){
        manager = msg.sender;
        lotteryId = 1;
    }

    // Pay ether to enter in the lottery
    function enter() public payable {
        require(msg.value == 1 ether, "You should pay 1 ether to enter in the lottery.");
        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    // Function to check the total balance received
    function getBalance() public view returns(uint){
        require(msg.sender == manager,"Only manager can check the balance.");
        return address(this).balance;
    }

    // Function to generate the random generator
    // This type of random generator logic should not be used for production level applications.
    // Only for development/ practice applications
    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // Function to pick the winner randomly from the pool of participants
    function pickWinner() public{
        require(msg.sender == manager,"Only manager can pick the winner.");
        require (players.length >= 3,"Minimum 3 players is required to play the lottery.");

        uint r = random();
        address payable winner;

        uint index = r % players.length;

        winner = players[index];
        winner.transfer(getBalance());

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;

        players = new address payable[](0); // Reset the players array after the game is over
    }

}



//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract CandyShop{
    uint CandyPrice = 0.01 ether;
    address owner;
    mapping (address => uint) public CandyHolders; // Mapping to hold the record of person having candies

    constructor(){
        owner=msg.sender;
    }

    function addCandies(address _user, uint _amount) internal{
        CandyHolders[_user]+=_amount;
    }

    function subCandies(address _user, uint _amount) internal{
        require(CandyHolders[_user] >= _amount, "You do not have enough Candies.");
        CandyHolders[_user]-=_amount;
    }

    function buyCandies(address _user, uint _amount) payable public{
        require(msg.value >= CandyPrice * _amount);
        addCandies(_user, _amount);
    }

    function distributeCandies(address _user, uint _amount) public{
        subCandies(_user, _amount);
    }

    // Function to get the total balance
    function getBalance() public view returns(uint){
        require(msg.sender == owner, "Only owner can check the total balance.");
        return address(this).balance;
    }

    // Function for shop owner to withdraw the money 
    function withdrawEth() public{
        require(msg.sender == owner, "Only owner can withdraw the money.");
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }
    
}
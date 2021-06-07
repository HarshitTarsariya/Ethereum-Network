// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

//Understanding mapping

contract Mapping{
    mapping(address=>uint) deposited;
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function addMoney() public payable{
        deposited[msg.sender]=msg.value;
    }
    function withDraw(uint _amount) public{
        require(deposited[msg.sender]>=_amount,"Not enough Balance");
        deposited[msg.sender]-=_amount;
        address payable add=payable(msg.sender);
        add.transfer(_amount);
    }
    
}
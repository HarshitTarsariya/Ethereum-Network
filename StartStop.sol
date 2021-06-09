// SPDX-License-Identifier: GPL-3.0
//securing it with ownership
pragma solidity ^0.8.1;

contract StartStop{
    
    address owner;
    constructor(){
        owner=msg.sender;
    }
    function receiveMoney() public payable{
        
    }
    function withDraw(address payable _to) public{
        require(msg.sender == owner,"You Donot Have Access");
        _to.transfer(address(this).balance);
    }
}
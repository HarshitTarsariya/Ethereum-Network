// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

//Understanding mapping eg.blacklisting or admin access feature

contract Mapping{
    mapping(address=>bool) whitelist;
    constructor(){
        whitelist[msg.sender]=true;
    }
    function Register() public{
        require(whitelist[msg.sender] == false,"You are already registered");
        whitelist[msg.sender]=true;
    }
    
}
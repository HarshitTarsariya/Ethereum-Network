// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import "./ItemManager.sol";

contract Item{
    uint public priceInWei;
    uint public index;
    bool paid;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract,uint _priceInWei,uint _index){
        priceInWei=_priceInWei;
        index=_index;
        parentContract=_parentContract;
        paid=false;
    }
     
    receive() external payable{
        require(msg.value==priceInWei,"You should fully pay");
        require(paid==false,"You have already Paid");
        (bool success,)=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success,"Payment Failed!");
        paid=true;
    }
}
// SPDX-License-Identifier: MIT OR unlicensed
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ControlledTransfer is Ownable {

    uint256 constant private AMOUNT_TO_SEND = 0.5 ether;

    constructor() Ownable(msg.sender) {}
    
    // Function to automatically deposit Ether into the contract
    function deposit() external payable onlyOwner {}

    // Function to send Ether to a recipient
    function sendEther(address payable recipient) public onlyOwner {
        require(AMOUNT_TO_SEND <= address(this).balance, "Insufficient balance in contract");
        recipient.transfer(AMOUNT_TO_SEND);
    }

    // Function to get the contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // receive and fallback to handle unexpected transactions
    receive() external payable {}
    fallback() external payable {}
}

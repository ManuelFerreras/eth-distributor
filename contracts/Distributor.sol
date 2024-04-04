// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Distributor is Ownable, ReentrancyGuard {

  constructor(address _owner) Ownable(_owner) {}

  function distribute(address[] memory _addresses, uint256[] memory _amounts) public payable nonReentrant {
    require(_addresses.length > 0, "Addresses array must not be empty");
    require(_addresses.length == _amounts.length, "Addresses and amounts arrays must be the same length");

    uint256 totalAmount = 0;

    for (uint256 i = 0; i < _addresses.length; i++) {
      payable(_addresses[i]).transfer(_amounts[i]);
      totalAmount += _amounts[i];
    }

    require(totalAmount == msg.value, "Total amount must be equal to the sent value");
  }

  function takeExcesiveFunds(address _to) public onlyOwner nonReentrant {
    payable(_to).transfer(address(this).balance);
  }

  receive() external payable {
    revert();
  }
}
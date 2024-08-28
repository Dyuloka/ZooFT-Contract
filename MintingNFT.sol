// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CustomNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public maxSupply;
    uint256 public mintPrice;
    string public baseTokenURI;
    bool public initialized = false;

    constructor() ERC721("PlaceholderName", "PLH") Ownable(msg.sender) {}

    function initialize(
        string memory name, 
        string memory symbol,
        string memory baseURI,
        uint256 _maxSupply
    ) public onlyOwner {
        require(!initialized, "Contract is already initialized");
        baseTokenURI = baseURI;
        maxSupply = _maxSupply;
        mintPrice = 0.01 ether; // Set minting price to 0.01 ETH
        initialized = true;

        // Set contract metadata (name and symbol) to match ERC721 constructor
        _setNameAndSymbol(name, symbol);
    }

    // Internal function to set name and symbol
    function _setNameAndSymbol(string memory name, string memory symbol) internal {
        // Directly use ERC721 functions
        // You would typically need to handle this through other mechanisms, as OpenZeppelin ERC721 does not allow direct modification.
        // We might override _beforeTokenTransfer and other functions to use internal state variables.
    }

    // Function to mint a new NFT
    function mintNFT(address recipient) public payable returns (uint256) {
        require(_tokenIds.current() < maxSupply, "Max supply reached");
        require(msg.value == mintPrice, "Incorrect ETH amount sent");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        string memory tokenURI = string(abi.encodePacked(baseTokenURI, Strings.toString(newItemId), ".json"));

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    // Function to withdraw the contract's balance
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        payable(owner()).transfer(balance);
    }

    // Function to get the current number of minted tokens
    function totalMinted() public view returns (uint256) {
        return _tokenIds.current();
    }

    // Override baseURI function
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
}

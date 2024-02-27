 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.20;

 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
 
 contract D4n13lNFT is ERC721URIStorage{
    constructor(address _to, uint256 _tokenID, string memory _uri) ERC721("Multimedia Posts", "DNL") {

         _mint(_to, _tokenID);
        _setTokenURI(_tokenID, _uri); 
    }

}
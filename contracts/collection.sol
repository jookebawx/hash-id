// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/MyToken.sol";
contract Collection is Token {
    // Mapping from token ID to token URI
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => uint256) private _tokenBlockHeight;
    mapping(uint256 => address) private _tokenMaker;
    // Mapping to track if a token ID has been minted
    mapping(uint256 => bool) private _tokenExists;
    mapping(address => uint256[]) private _ownedTokens;

    constructor(string memory _name) Token(_name) {}

    // Function to set the token URI for a specific token ID
    function _setTokenURI_(uint256 tokenID, string memory TokenURI) internal {
        require(!_tokenExists[tokenID], "Token does not exist");
        _tokenURIs[tokenID] = TokenURI;
    }

    // Function to get the token URI for a specific token ID
    function tokenMetadata(string memory doc_hash) public view returns (uint256, address, string memory, address) {
        uint256 tokenID = _stringToUint(doc_hash);
        require(_tokenExists[tokenID], "Token does not exist");
        address owner = _ownerOf(tokenID);
        
        return (_tokenBlockHeight[tokenID],_tokenMaker[tokenID],_tokenURIs[tokenID],owner);
    }
    function owned_token(address owneraddress) public view returns(uint256[] memory){
        return(_ownedTokens[owneraddress]);
    }
    // Function to mint a token and set its URI
     function mint(string memory ipfshash, string memory doc_hash) public {
        uint256 tokenID = _stringToUint(doc_hash);
        require(!_tokenExists[tokenID], "Token already minted");

        // Construct the token URI
        string memory tokenuri = string(abi.encodePacked("https://coral-far-pheasant-311.mypinata.cloud/ipfs/", ipfshash));
        
        // Mint the token
        _mint(msg.sender, tokenID);

        // Set the token URI
        _ownedTokens[msg.sender].push(tokenID);
        _setTokenURI_(tokenID, tokenuri);
        _tokenBlockHeight[tokenID]=block.number;
        _tokenMaker[tokenID]= msg.sender;
        // Mark the token ID as minted
        _tokenExists[tokenID] = true;
    }

    function _stringToUint(string memory s) private pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint i = 0; i < b.length; i++) {
            uint8 c = uint8(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 16 + (c - 48); // 0-9
            } else if (c >= 65 && c <= 70) {
                result = result * 16 + (c - 55); // A-F
            } else if (c >= 97 && c <= 102) {
                result = result * 16 + (c - 87); // a-f
            }
        }
        return result;
    }
}
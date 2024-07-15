// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


abstract contract Token is ERC721, Ownable {
    string private _baseTokenURI;
    string private name_;
    mapping(uint256 => bool) private _tokenExists;

    constructor(string memory _name) ERC721("NFT", "NFT") Ownable(msg.sender) {
        name_ = _name;
    }

    function mint(uint256 tokenId) internal  {
        
        _mint(msg.sender, tokenId);
        _tokenExists[tokenId] = true;
    }

    function burn(uint256 tokenId) public onlyOwner {
        require(_tokenExists[tokenId], "Token does not exist");
        _burn(tokenId);
        delete _tokenExists[tokenId];
    }
    
    function setBaseURI(uint tokenId, string memory baseURI) internal {
        require(!_tokenExists[tokenId], "Token already minted");
        _baseTokenURI = baseURI;
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721)
        returns (address)
    {
        address from = _ownerOf(tokenId);
        if (from != address(0) && to != address(0)) {
            revert("Soulbound: Transfer failed");
        }

        return super._update(to, tokenId, auth);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}

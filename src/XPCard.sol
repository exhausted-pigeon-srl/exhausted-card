//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title    Exhausted Pigeon Business NFT-Card
 * @author   drgorilla.eth
 * @website  https://www.exhausted-pigeon.xyz
*/
contract ExhaustedPigeonCard is ERC721 {

    constructor() ERC721("ExhaustedPigeon", "BCard") {}

    function mint() public {
        _mint(msg.sender, uint256(uint160(msg.sender)));
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        address _owner = _ownerOf(id);

        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    string.concat(

                    )
                )
            )
        );

        return
                string.concat(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            string.concat(
                                '{"name":"Exhausted Pigeon Virtual Card", "image":"',
                                image,
                                unicode'", "description": "www.exhausted-pigeon.xyz"}'
                            )
                        )
                    )
                )
            ;
    }

    /* ========== HELPER FUNCTIONS ========== */

    function _uintToString(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    function _addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = _char(hi);
            s[2 * i + 1] = _char(lo);
        }
        return string(s);
    }

    function _char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
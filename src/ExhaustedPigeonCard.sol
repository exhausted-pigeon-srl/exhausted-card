//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title           Exhausted Pigeon Business NFT-Card
 * @author          drgorilla.eth
 * @custom:website  https://www.exhausted-pigeon.xyz
*/
contract ExhaustedPigeonCard is ERC721 {
    uint256 internal _nonce;

    constructor() ERC721("ExhaustedPigeon", "BCard") {}

    function mint() public {
        _mint(msg.sender, ++_nonce);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        address _owner = _ownerOf(id);

        if(_owner == address(0)) return "";

        uint256 _balance = _owner.balance;

        // 3 decimals precision, in eth: A.BCD
        string memory _balanceString = string.concat(
            Strings.toString(_balance / 1 ether), // A
            '.',
            Strings.toString(_balance % 1 ether / 0.001 ether) // BCD
        );

        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    string.concat(
                        '<svg viewBox="0 0 400 400" version="1.1" xmlns="http://www.w3.org/2000/svg">',

                        '<defs>',
                            '<linearGradient id="Gr">',
                            '<stop offset="0%" stop-color="red" />',
                            '<stop offset="100%" stop-color="green" />',
                            '</linearGradient>',
                        '</defs>',

                        '<rect width="400" height="400" fill="#343735"/>',

                        '<path style="fill:#e6e6e6" d="M 336.44778,4.94955 C 328.20347,4.90315 318.19253,6.92616 305.93979,11.57463 329.67611,57.68161 312.35219,83.872732 285.15015,105.2716 309.00742,106.54409 327.89437,97.734324 337.67094,70.44324 357.34759,67.7405 362.51814,61.16796 368.22221,54.73891 L 394.85819,52.42633 375.72827,46.26534 C 370.00814,23.85765 361.18074,5.08866 336.44778,4.94955 Z M 324.19661,24.67533 339.9835,34.3229 354.2956,24.87198 340.24505,38.65899 Z M 6.11521,106.08643 290.78016,16.34453 C 329.0098,59.41074 278.94781,104.34899 256.2454,105.85202 L 190.64347,107.20636 242.63844,53.88969 237.30631,48.46985 181.29835,106.19889 Z"/>',
                        
                        '<text style="font-size:42.6667px;font-family:sans-serif;fill:#e6e6e6" x="8" y="146">Exhausted Pigeon</text>',
                        '<text style="font-style:italic;font-size:26.6667px;font-family:sans-serif;fill:#e6e6e6" x="42" y="180">Blockchain Engineering</text>',
                        '<text style="font-size:16px;font-family:sans-serif;fill:#e6e6e6" x="18" y="255">This NFT business card is currently owned by</text>',
                        '<text style="font-size:14px;font-family:sans-serif;fill:#e6e6e6" x="14" y="275">0x', _addressToString(_owner), '</text>',
                        '<text style="font-size:14px;font-family:sans-serif;fill:#e6e6e6" x="14" y="290">(', _balanceString, 'ETH)</text>',
                        '<rect style="fill:url(#Gr)" width="380" height="31" x="10" y="300"/>',
                        '<text style="font-size:16px;font-family:sans-serif;fill:#000000" x="', Strings.toString( _balance <= 100 ether ? _balance * 385 / 100 ether : 385 ),'" y="320">X</text>',
                        '<text style="font-size:10px;font-family:sans-serif;fill:#e6e6e6" x="10" y="350">poor af</text>',
                        '<text style="font-size:10px;font-family:sans-serif;fill:#e6e6e6" x="360" y="350">whale</text>',
                        '<text style="font-size:28px;font-family:sans-serif; fill: #ffffff;" x="8" y="380" >www.exhausted-pigeon.xyz</text>',
                        '</svg>'
                    )
                )
            )
        );

        return
                string.concat(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
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
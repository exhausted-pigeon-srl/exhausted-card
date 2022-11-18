// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ExhaustedPigeonCard.sol";

contract ExhaustedPigeonCard_Test is Test {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    ExhaustedPigeonCard _card;

    function setUp() public {
        _card = new ExhaustedPigeonCard();
    }

    function test_mint_shouldMintAndEmitEvent(uint8 _quantity) public {
        vm.assume(_quantity > 0 && _quantity < 15);

        // Mint _quantity token

        for(uint256 i; i < _quantity; ++i) {
            // Check: correct events (starts at 1 - 3 indexed args only)
            vm.expectEmit(true, true, true, false, address(_card));
            emit Transfer(address(0), address(this), i + 1);

            _card.mint();

            // Check: correct owner (used for onchain svg)?
            assertEq(_card.ownerOf(i + 1), address(this));
        }
        
        // Check: balance is irrelevant?
        assertEq(_card.balanceOf(address(this)), 1);
    }

    function test_tokenUri_shouldReturnCorrectTokenUri() public {
        // Set the sending address, used in the svg
        address _sender = address(69420);
        vm.label(_sender, "_sender");

        // Mint one token
        vm.prank(_sender);
        _card.mint();
        
        // Check: is the valid base64 uri returned?
        assertEq(_card.tokenURI(1), "data:application/json;base64,eyJuYW1lIjoiRXhoYXVzdGVkIFBpZ2VvbiBWaXJ0dWFsIENhcmQiLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ05EQXdJRFF3TUNJZ2RtVnljMmx2YmowaU1TNHhJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lQanhrWldaelBqeHNhVzVsWVhKSGNtRmthV1Z1ZENCcFpEMGlSM0lpUGp4emRHOXdJRzltWm5ObGREMGlNQ1VpSUhOMGIzQXRZMjlzYjNJOUluSmxaQ0lnTHo0OGMzUnZjQ0J2Wm1aelpYUTlJakV3TUNVaUlITjBiM0F0WTI5c2IzSTlJbWR5WldWdUlpQXZQand2YkdsdVpXRnlSM0poWkdsbGJuUStQQzlrWldaelBqeHlaV04wSUhkcFpIUm9QU0kwTURBaUlHaGxhV2RvZEQwaU5EQXdJaUJtYVd4c1BTSWpNREF3TURBd0lpOCtQSEJoZEdnZ2MzUjViR1U5SW1acGJHdzZJMlUyWlRabE5pSWdaRDBpVFNBek16WXVORFEzTnpnc05DNDVORGsxTlNCRElETXlPQzR5TURNME55dzBMamt3TXpFMUlETXhPQzR4T1RJMU15dzJMamt5TmpFMklETXdOUzQ1TXprM09Td3hNUzQxTnpRMk15QXpNamt1TmpjMk1URXNOVGN1TmpneE5qRWdNekV5TGpNMU1qRTVMRGd6TGpnM01qY3pNaUF5T0RVdU1UVXdNVFVzTVRBMUxqSTNNVFlnTXpBNUxqQXdOelF5TERFd05pNDFORFF3T1NBek1qY3VPRGswTXpjc09UY3VOek0wTXpJMElETXpOeTQyTnpBNU5DdzNNQzQwTkRNeU5DQXpOVGN1TXpRM05Ua3NOamN1TnpRd05TQXpOakl1TlRFNE1UUXNOakV1TVRZM09UWWdNelk0TGpJeU1qSXhMRFUwTGpjek9Ea3hJRXdnTXprMExqZzFPREU1TERVeUxqUXlOak16SURNM05TNDNNamd5Tnl3ME5pNHlOalV6TkNCRElETTNNQzR3TURneE5Dd3lNeTQ0TlRjMk5TQXpOakV1TVRnd056UXNOUzR3T0RnMk5pQXpNell1TkRRM056Z3NOQzQ1TkRrMU5TQmFJRTBnTXpJMExqRTVOall4TERJMExqWTNOVE16SURNek9TNDVPRE0xTERNMExqTXlNamtnTXpVMExqSTVOVFlzTWpRdU9EY3hPVGdnTXpRd0xqSTBOVEExTERNNExqWTFPRGs1SUZvZ1RTQTJMakV4TlRJeExERXdOaTR3T0RZME15QXlPVEF1Tnpnd01UWXNNVFl1TXpRME5UTWdReUF6TWprdU1EQTVPQ3cxT1M0ME1UQTNOQ0F5TnpndU9UUTNPREVzTVRBMExqTTBPRGs1SURJMU5pNHlORFUwTERFd05TNDROVEl3TWlCTUlERTVNQzQyTkRNME55d3hNRGN1TWpBMk16WWdNalF5TGpZek9EUTBMRFV6TGpnNE9UWTVJREl6Tnk0ek1EWXpNU3cwT0M0ME5qazROU0F4T0RFdU1qazRNelVzTVRBMkxqRTVPRGc1SUZvaUx6NDhkR1Y0ZENCemRIbHNaVDBpWm05dWRDMXphWHBsT2pReUxqWTJOamR3ZUR0bWIyNTBMV1poYldsc2VUcHpZVzV6TFhObGNtbG1PMlpwYkd3NkkyVTJaVFpsTmlJZ2VEMGlPQ0lnZVQwaU1UUTJJajVGZUdoaGRYTjBaV1FnVUdsblpXOXVQQzkwWlhoMFBqeDBaWGgwSUhOMGVXeGxQU0ptYjI1MExYTjBlV3hsT21sMFlXeHBZenRtYjI1MExYTnBlbVU2TWpZdU5qWTJOM0I0TzJadmJuUXRabUZ0YVd4NU9uTmhibk10YzJWeWFXWTdabWxzYkRvalpUWmxObVUySWlCNFBTSTBNaUlnZVQwaU1UZ3dJajVDYkc5amEyTm9ZV2x1SUVWdVoybHVaV1Z5YVc1blBDOTBaWGgwUGp4MFpYaDBJSE4wZVd4bFBTSm1iMjUwTFhOcGVtVTZNVFp3ZUR0bWIyNTBMV1poYldsc2VUcHpZVzV6TFhObGNtbG1PMlpwYkd3NkkyVTJaVFpsTmlJZ2VEMGlNVGdpSUhrOUlqSTFOU0krVkdocGN5Qk9SbFFnWW5WemFXNWxjM01nWTJGeVpDQnBjeUJqZFhKeVpXNTBiSGtnYjNkdVpXUWdZbms4TDNSbGVIUStQSFJsZUhRZ2MzUjViR1U5SW1admJuUXRjMmw2WlRveE5IQjRPMlp2Ym5RdFptRnRhV3g1T25OaGJuTXRjMlZ5YVdZN1ptbHNiRG9qWlRabE5tVTJJaUI0UFNJeE5DSWdlVDBpTWpjMUlqNHdlREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01EQXdNVEJtTW1NOEwzUmxlSFErUEhSbGVIUWdjM1I1YkdVOUltWnZiblF0YzJsNlpUb3hOSEI0TzJadmJuUXRabUZ0YVd4NU9uTmhibk10YzJWeWFXWTdabWxzYkRvalpUWmxObVUySWlCNFBTSXhOQ0lnZVQwaU1qa3dJajRvTUM0d1JWUklLVHd2ZEdWNGRENDhjbVZqZENCemRIbHNaVDBpWm1sc2JEcDFjbXdvSTBkeUtTSWdkMmxrZEdnOUlqTTRNQ0lnYUdWcFoyaDBQU0l6TVNJZ2VEMGlNVEFpSUhrOUlqTXdNQ0l2UGp4MFpYaDBJSE4wZVd4bFBTSm1iMjUwTFhOcGVtVTZNVFp3ZUR0bWIyNTBMV1poYldsc2VUcHpZVzV6TFhObGNtbG1PMlpwYkd3Nkl6QXdNREF3TUNJZ2VEMGlNQ0lnZVQwaU16SXdJajVZUEM5MFpYaDBQangwWlhoMElITjBlV3hsUFNKbWIyNTBMWE5wZW1VNk1UQndlRHRtYjI1MExXWmhiV2xzZVRwellXNXpMWE5sY21sbU8yWnBiR3c2STJVMlpUWmxOaUlnZUQwaU1UQWlJSGs5SWpNMU1DSStjRzl2Y2lCaFpqd3ZkR1Y0ZEQ0OGRHVjRkQ0J6ZEhsc1pUMGlabTl1ZEMxemFYcGxPakV3Y0hnN1ptOXVkQzFtWVcxcGJIazZjMkZ1Y3kxelpYSnBaanRtYVd4c09pTmxObVUyWlRZaUlIZzlJak0yTUNJZ2VUMGlNelV3SWo1M2FHRnNaVHd2ZEdWNGRENDhkR1Y0ZENCemRIbHNaVDBpWm05dWRDMXphWHBsT2pJNGNIZzdabTl1ZEMxbVlXMXBiSGs2YzJGdWN5MXpaWEpwWmpzZ1ptbHNiRG9nSTJabVptWm1aanNpSUhnOUlqZ2lJSGs5SWpNNE1DSWdQbmQzZHk1bGVHaGhkWE4wWldRdGNHbG5aVzl1TG5oNWVqd3ZkR1Y0ZEQ0OEwzTjJaejQ9IiwgImRlc2NyaXB0aW9uIjogInd3dy5leGhhdXN0ZWQtcGlnZW9uLnh5eiJ9");
    }

    function test_tokenUri_revertIfNotMinted(uint256 _tokenId) public {
        vm.expectRevert(abi.encodeWithSignature("ExhaustedPigeonCard_NotMinted()"));
        _card.tokenURI(_tokenId);
    }
}

pragma solidity ^0.5.0;

import "./GaoOwnership.sol";

contract GaoFusion is GaoOwnership {

    event Fusion(address owner, uint256 gaoId);

    function random() private view returns (uint16) {
        return uint16(uint256(keccak256(block.timestamp, block.difficulty))%101);
    }

    function _genarateDna(uint16 bonding) internal returns (uint16[4]){
        uint16 head = random();
        uint16 wings = random();
        uint16 hands = random();
        uint16 legs = random();
        uint16[4] _dna = [head, wings, hands, legs];
        return _dna;
    }

    function _genarateAbility(uint16 bonding) internal returns (uint16[3]){
        uint16 fly = random();
        uint16 swim = random();
        uint16 run = random();
        uint16[3] _ability = [fly, swim, run];
        return _ability;
    }

    function _isReadyToFuse(Gao _gao) internal view returns (bool) {
        return (!_gao.mature) && (_gao.bonding > 0);
    }

    function isReadyToFuse(uint256 _gaoId) public view returns (bool) {
        require(_gaoId > 0);
        Gao storage gao = gaos[_gaoId];
        return _isReadyToFuse(gao);
    }

    function _fuseGao(Gao _gao) internal {
        _gao.mature = true;
    }

    function fuseGao (uint256 _gaoId) external {
        require(_gaoId > 0);
        _fuseGao(gaos[_gaoId]);
    }
}

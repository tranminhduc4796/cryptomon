pragma solidity ^0.5.0;

import "./Ownable.sol";
import "./safemath.sol";

contract GaoFactory is Migrations {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewGao(address owner, uint256 gaoID, uint16 gao_type, uint origin, bool mature, uint64 birthTime, uint16 bonding, uint16 level);

    event Transfer(address from, address to, uint256 tokenId);

    struct Gao {
        bool mature;
        uint origin; // {1:'phoenix', 2:'bat'}
        uint64 birthTime;
        uint32 eventID;
        uint16 bonding; // Max 100
        uint16 level; // Max 100
        uint16 gao_type; // common, rare, legend
        uint16[4] dna; // head, wings, hands, legs
        uint16[3] ability; // [fly, swim, run]
    }

    Gao[] public gaos;

    mapping (uint256 => address) public gaoIndexToOwner;
    mapping (address => uint256) ownershipTokenCount;
    mapping (uint256 => address) public gaoIndexToApproved;

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        ownershipTokenCount[_to]++;
        // transfer ownership
        gaoIndexToOwner[_tokenId] = _to;
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            delete gaoIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
        emit Transfer(_from, _to, _tokenId);
    }

    function _createGao(
        address _owner,
        uint _origin,
        uint16 _gao_type,
        uint32 _eventId
    ) internal returns (uint) {
        Gao memory _gao = Gao({
            mature: false,
            origin: _origin,
            birthTime: uint64(now),
            eventID: _eventId,
            bonding: 0,
            level: 1,
            gao_type: _gao_type,
            dna: [uint16(0), uint16(0), uint16(0), uint16(0)],
            ability: [uint16(0), uint16(0), uint16(0)]
            });
        uint256 newGaoId = gaos.push(_gao) - 1;

        // Make sure number of Gao never cross 4 billion.
        require(newGaoId == uint256(uint32(newGaoId)));

        //emit event NewGao
        emit NewGao(_owner, newGaoId, _gao.gao_type, _gao.origin, _gao.mature, _gao.birthTime,  _gao.bonding, _gao.level);

        _transfer(address(0), _owner, newGaoId);
        return newGaoId;
    }

    struct GaoEvents {
        uint16[3] requirements; //requirements about abiblity
        uint64 startTime;
        uint64 endTime;
        uint16 kind;
        uint joinFee;
    }
}
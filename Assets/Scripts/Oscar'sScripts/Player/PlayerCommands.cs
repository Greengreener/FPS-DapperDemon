using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

public class PlayerCommands : NetworkBehaviour
{
    public void Damage(float _damage, PlayerCommands _toDamage)
    {
        if (isLocalPlayer)
        {
            CmdDamage(_damage, _toDamage.netId);
        }
    }

    [Command]
    public void CmdDamage(float _damage, uint _networkId)
    {
        RpcDamage(_damage, _networkId);
    }

    [ClientRpc]
    public void RpcDamage(float _damage, uint _networkId)
    {
        PlayerCommands[] players = FindObjectsOfType<PlayerCommands>();
        foreach (PlayerCommands player in players)
        {
            if (player.netId == _networkId)
            {
                player.GetComponent<Health>().Damage(_damage);
            }
        }
    }
}

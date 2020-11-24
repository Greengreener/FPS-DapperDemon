using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using TMPro;
using UnityEngine.UI;

public class NetworkGamePlayer : NetworkBehaviour
{
    [SyncVar]
    //sets the default display name
    private string displayName = "Loading...";
    //desiginates the network manager lobby
    private NetworkManagerLobby room;
    //creates a 
    private NetworkManagerLobby Room
    {
        get
        {
            if( room != null)
            {
                return room;
            }
            room = NetworkManager.singleton as NetworkManagerLobby;
            return room;
        }
    }

    public override void OnStartClient()
    {
        //ensues this object is not destroyed on load
        DontDestroyOnLoad(gameObject);
        //adds this to the room's gameplayers
        Room.GamePlayers.Add(this);
    }

    public override void OnNetworkDestroy()
    {
        //removes this from the room on destruction
        Room.GamePlayers.Remove(this);
    }

    [Server]
    public void SetDisplayName(string displayName)
    {
        //alters the display name
        this.displayName = displayName;
    }

}

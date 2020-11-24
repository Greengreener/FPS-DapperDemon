using Mirror;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Experimental.XR;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class NetworkManagerLobby : NetworkManager
{
    //sets the minimum amount of players nessary to play the game
    [SerializeField] private int minPlayers = 2;
    //makes the menuscene string empty
    [Scene][SerializeField] private string menuScene = string.Empty;

    [Header("Room")]
    //desiginates a network room player called room player prefab
    [SerializeField] private NetworkRoomPlayer roomPlayerPrefab = null;

    [Header("Game")]
    //desiginates a network game player called game player prefab
    [SerializeField] private NetworkGamePlayer gamePlayerPrefab = null;
    //desiginates a player spawn system as null
    [SerializeField] private GameObject playerSpawnSystem = null;

    //creates a bool for the two teams
    private bool TeamA;
    //creates an action called on client connected
    public event Action onClientConnected;
    //creates an action called on client disconnected
    public event Action onClientDisconnected;
    //creates a fixed action based on network connection called on server readied
    public static event Action<NetworkConnection> onServerReadied;
    //creates a list of network room players called room players
    public List<NetworkRoomPlayer> RoomPlayers { get; } = new List<NetworkRoomPlayer>();
    //creates a list of network game players called game players
    public List<NetworkGamePlayer> GamePlayers { get; } = new List<NetworkGamePlayer>();

    public override void OnStartServer()
    {
        //loads the prefabs so you can spawn them
        spawnPrefabs = Resources.LoadAll<GameObject>("SpawnablePrefabs").ToList<GameObject>();
    }

    public override void OnStartClient()
    {
        
        var spawnablePrefabs = Resources.LoadAll<GameObject>("SpawnablePrefabs");

        foreach(var prefab in spawnablePrefabs)
        {
            //register the prefabs so they can be used
            ClientScene.RegisterPrefab(prefab);
        }
    }

    public override void OnClientConnect(NetworkConnection conn)
    {

        base.OnClientConnect(conn);
        //if the onclient connected then invoke
        onClientConnected?.Invoke();
    }

    public override void OnClientDisconnect(NetworkConnection conn)
    {
        base.OnClientDisconnect(conn);
        //if the onclient disconnected then invoke
        onClientDisconnected?.Invoke();
    }

    public override void OnServerConnect(NetworkConnection conn)
    {
        //limits the number of players based on the max connections
        if(numPlayers >= maxConnections)
        {
            conn.Disconnect();
            return;
        }

        //only if we want people to join only in the lobby
        if(SceneManager.GetActiveScene().path != menuScene)
        {
            conn.Disconnect();
            return;
        }
    }

    public override void OnServerAddPlayer(NetworkConnection conn)
    {
        //spawns the player into the scene
        if (SceneManager.GetActiveScene().path == menuScene)
        {
            bool isLeader = RoomPlayers.Count == 0;

            NetworkRoomPlayer roomPlayerInstance0 = Instantiate(roomPlayerPrefab);
            
            roomPlayerInstance0.IsLeader = isLeader;
          
            NetworkServer.AddPlayerForConnection(conn, roomPlayerInstance0.gameObject);
           
        }
    }


    public override void OnServerDisconnect(NetworkConnection conn)
    {
        //removes players when a disconnect occurs so they aren't affected by the world
        if(conn.identity != null)
        {
            NetworkRoomPlayer player = conn.identity.GetComponent<NetworkRoomPlayer>();

            RoomPlayers.Remove(player);

            NotifyPlayersOfReadyState();
        }

        base.OnServerDisconnect(conn);
    }

    public override void OnStopServer()
    {
        //removes all the players from the scene at the end of the game
        RoomPlayers.Clear();
    }

    public void NotifyPlayersOfReadyState()
    {
        //makes all the room players ready to start
        foreach (var player in RoomPlayers)
        {
            player.HandleReadyToStart(IsReadyToStart());
        }
    }

    private bool IsReadyToStart()
    {
        //if the number of players is equal or greater then the number of players then start the game
        if(numPlayers < minPlayers)
        {
            return false;
        }

        foreach(var player in RoomPlayers)
        {
            if(!player.IsReady)
            {
                return false;
            }
        }

        return true;
    }


    public override void OnServerReady(NetworkConnection conn)
    {
        base.OnServerReady(conn);
        //if server is ready then invoke
        onServerReadied?.Invoke(conn);
    }

    public void StartGame()
    {   
        //changes the scene to a specific scene so the game can begin
        if(SceneManager.GetActiveScene().path == menuScene)
        {
            if(!IsReadyToStart())
            {
                return;
            }

            ServerChangeScene("MitchellTest");
        }
    }

    
    public override void ServerChangeScene(string newSceneName)
    {
        //from menu to game
        if(SceneManager.GetActiveScene().path == menuScene && newSceneName.StartsWith("MitchellTest"))
        {
            //if you have the right scne to change to then you spawn all the players into the scene
            for(int i = RoomPlayers.Count -1; i >= 0; i--)
            {
                var conn = RoomPlayers[i].connectionToClient;
                NetworkGamePlayer gamePlayerInstance = Instantiate(gamePlayerPrefab);
                gamePlayerInstance.SetDisplayName(RoomPlayers[i].DisplayName);

                NetworkServer.Destroy(conn.identity.gameObject);

                NetworkServer.ReplacePlayerForConnection(conn, gamePlayerInstance.gameObject, true);
            }
        }


        base.ServerChangeScene(newSceneName);
    }

    public override void OnServerSceneChanged(string sceneName)
    {
        //adds the spawn system when the scene changes
        if (sceneName.StartsWith("MitchellTest"))
        {
            GameObject playerSpawnSystemInstanceA = Instantiate(playerSpawnSystem);
            
                NetworkServer.Spawn(playerSpawnSystemInstanceA);
            
            
        }
    }
}

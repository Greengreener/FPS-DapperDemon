using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using TMPro;
using UnityEngine.UI;

using System.Net;


    public class NetworkRoomPlayer : NetworkBehaviour
    {
    /// <summary>
    /// this scripts shows you all of the individual players in the room and shows their states
    /// </summary>
        [Header("UI")]
        //designates a lobbyUI
        [SerializeField] private GameObject lobbyUI = null;
        //adds two player name texts
        [SerializeField] private Text[] playerNameTexts = new Text[2];
        //adds two player ready texts
        [SerializeField] private Text[] playerReadyTexts = new Text[2];
        //desiginates an input field called lobbyname 
    [SerializeField] private InputField lobbyName;
        //desiginates a button called start game button
        [SerializeField] private Button startGameButton = null;
        //adds a bool called TeamID
        private bool TeamID;
        //adds a Network Manager Lobby calles network manager
    [SerializeField] private NetworkManagerLobby networkManager = null;
    //adds a network room player called room manager
    [SerializeField] private NetworkRoomPlayer RoomManager = null;

    [SyncVar(hook = nameof(HandleDisplayNameChanged))]
    //sets the display name string as loading by default
        public string DisplayName = "Loading...";
        [SyncVar(hook = nameof(HandleReadyStatusChanged))]
        //sets a bool called is ready to false
        public bool IsReady = false;
        //used to desiginate what is this self
        public GameObject self;
        //sets a bool called is leader false
        private bool isLeader = false;
        //matches the is leader based on whether the start game button is active
        public bool IsLeader
        {
            set
            {
                isLeader = value;
                if (startGameButton != null)
                {
                    startGameButton.gameObject.SetActive(value);
                }
            }
        }
    private void Start()
    {
        //sets the network manager
        networkManager = FindObjectOfType<NetworkManagerLobby>();
        //RoomManager = FindObjectOfType<NetworkRoomPlayer>();
        //self = this.gameObject;
       
    }
    private void Update()
    {
        
        if (networkManager.networkAddress != lobbyName.text)
        {
            string text = networkManager.networkAddress;
            IPHostEntry host;
            string localIP = "0.0.0.0";
            host = Dns.GetHostEntry(Dns.GetHostName());
            foreach(IPAddress ip in host.AddressList)
            {
                if(ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                {
                    localIP = ip.ToString();
                    break;
                }
            }

            lobbyName.text = localIP;
        }
    }
    private NetworkManagerLobby room;
        private NetworkManagerLobby Room
        {
            get
            {//sets the Room to the network manager manager
                if (room != null)
                {
                    return room;
                }
                room = NetworkManager.singleton as NetworkManagerLobby;
                return room;
            }
        }

        public override void OnStartAuthority()
        {
                //displays the players name when you join the lobby
            CmdSetDisplayName(PlayerNameInput.DisplayName);

            lobbyUI.SetActive(true);
        }

        public override void OnStartClient()
        {
            //adds this script to the room players
            Room.RoomPlayers.Add(this);
            UpdateDisplay();
        }

        public override void OnStopClient()
        {
        //removes this script from the room players
            Room.RoomPlayers.Remove(this);
            UpdateDisplay();
        }
        //changes the display name
        public void HandleDisplayNameChanged(string oldValue, string newValue)
        {
            
            UpdateDisplay();
        }
        //changes the ready status
        public void HandleReadyStatusChanged(bool oldValue, bool newValue)
        {
            UpdateDisplay();
        }

        private void UpdateDisplay()
        { //updates the status of the players so you see who is ready and what are their names
            if (!isLocalPlayer)
            {
                foreach (var player in Room.RoomPlayers)
                {
                    if (player.isLocalPlayer)
                    {
                        player.UpdateDisplay();
                        break;
                    }
                }

                return;
            }

            for (int i = 0; i < playerNameTexts.Length; i++)
            {
                playerNameTexts[i].text = "Waiting for Player...";
                playerReadyTexts[i].text = string.Empty;
            }
            
        for (int i = 0; i < Room.RoomPlayers.Count; i++)
            {
                playerNameTexts[i].text = Room.RoomPlayers[i].DisplayName;
                playerReadyTexts[i].text = Room.RoomPlayers[i].IsReady ?
                        "<color=green>Ready</color>" :
                        "<color=red>Not Ready</color>";
            }
        
    }

        public void HandleReadyToStart(bool readyToStart)
        {
        //makes the start button interactable when you are ready to start
            if (!isLeader)
            {
                return;
            }

            startGameButton.interactable = readyToStart;
        }

        [Command]
        private void CmdSetDisplayName(string displayName)
        {
            //set the display name to this value
            this.DisplayName = displayName;
        }

        [Command]
        public void CmdReadyUp()
        {   
            //notifies the other players that you are ready
            IsReady = !IsReady;

            Room.NotifyPlayersOfReadyState();
        }

        [Command]
        public void CmdStartGame()
        {
            if (connectionToClient != Room.RoomPlayers[0].connectionToClient)
            {
                return;
            }
            //starts the game
            Room.StartGame();
        }
    }


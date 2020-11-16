﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using TMPro;
using UnityEngine.UI;

using System.Net;


    public class NetworkRoomPlayer : NetworkBehaviour
    {
        [Header("UI")]
        [SerializeField] private GameObject lobbyUI = null;
        [SerializeField] private Text[] playerNameTexts = new Text[2];
        [SerializeField] private Text[] playerReadyTexts = new Text[2];
    [SerializeField] private InputField lobbyName;
        [SerializeField] private Button startGameButton = null;
        private bool TeamID;
    [SerializeField] private NetworkManagerLobby networkManager = null;
    [SerializeField] private NetworkRoomPlayer RoomManager = null;
    [SyncVar(hook = nameof(HandleDisplayNameChanged))]
        public string DisplayName = "Loading...";
        [SyncVar(hook = nameof(HandleReadyStatusChanged))]
        public bool IsReady = false;
        public GameObject self;
        private bool isLeader = false;
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
        networkManager = FindObjectOfType<NetworkManagerLobby>();
        RoomManager = FindObjectOfType<NetworkRoomPlayer>();
        //self = this.gameObject;
        if (RoomManager != null)
        {
            Destroy(self);
        }
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
            {
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
            CmdSetDisplayName(PlayerNameInput.DisplayName);

            lobbyUI.SetActive(true);
        }

        public override void OnStartClient()
        {
            Room.RoomPlayers.Add(this);
            UpdateDisplay();
        }

        public override void OnStopClient()
        {
            Room.RoomPlayers.Remove(this);
            UpdateDisplay();
        }

        public void HandleDisplayNameChanged(string oldValue, string newValue)
        {
            UpdateDisplay();
        }

        public void HandleReadyStatusChanged(bool oldValue, bool newValue)
        {
            UpdateDisplay();
        }

        private void UpdateDisplay()
        {
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
            if (!isLeader)
            {
                return;
            }

            startGameButton.interactable = readyToStart;
        }

        [Command]
        private void CmdSetDisplayName(string displayName)
        {
            this.DisplayName = displayName;
        }

        [Command]
        public void CmdReadyUp()
        {
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

            Room.StartGame();
        }
    }


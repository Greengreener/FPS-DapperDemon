using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class JoinLobbyMenu : MonoBehaviour
{
    /// <summary>
    /// this allows you to join a server
    /// </summary>
    //access the Network manager lobby
    [SerializeField] private NetworkManagerLobby networkManager = null;

    [Header("UI")]
    //desiginate the landing page panel
    [SerializeField] private GameObject landingPagePanel = null;
    //desiginates an input field for the ip address
    [SerializeField] private TMP_InputField ipAddressInputField = null;
    //desiginates a button called join button
    [SerializeField] private Button joinButton = null;

    public void Start()
    {
        //adds logerror if you don't soming
        if(networkManager == null)
        {
            Debug.LogError("networkManager is not attached to JoinLobbyMenu");
        }
        if (landingPagePanel == null)
        {
            Debug.LogError("landingPagePanel is not attached to JoinLobbyMenu");
        }
        if (ipAddressInputField == null)
        {
            Debug.LogError("ipAddressInputField is not attached to JoinLobbyMenu");
        }
        if (joinButton == null)
        {
            Debug.LogError("joinButton is not attached to JoinLobbyMenu");
        }
    }

    private void OnEnable()
    {
        //adds the join button to the scene
        networkManager.onClientConnected += HandleClientConnected;
        networkManager.onClientDisconnected += HandleClientDisconnected;
    }

    private void OnDisable()
    {
        //removes the join buttonfrom the scene
        networkManager.onClientConnected -= HandleClientConnected;
        networkManager.onClientDisconnected -= HandleClientDisconnected;
    }

    public void JoinLobby()
    {
        // sets the ip address to the input field
        string ipAddress = ipAddressInputField.text;
        //sets the network address tot eh ip address
        networkManager.networkAddress = ipAddress;
        networkManager.StartClient();
        //Joins the lobby
        joinButton.interactable = false;
        //deactivates the join button
    }

    private void HandleClientConnected()
    {
        //shows the join button
        joinButton.interactable = true;
        //removes this gameobject
        gameObject.SetActive(false);
        //removes the landing page panel
        landingPagePanel.SetActive(false);
    }

    private void HandleClientDisconnected()
    {
        //gives you the ability to interact with the join button
        joinButton.interactable = true;
    }
}

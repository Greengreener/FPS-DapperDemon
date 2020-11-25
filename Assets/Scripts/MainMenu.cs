using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    /// <summary>
    /// this controls your the main menu in the lobby and lets you host
    /// </summary>
    //desiginates the network manager lobby
    [SerializeField] private NetworkManagerLobby networkManager = null;

    [Header("UI")]
    //desiginates a landing page panel
    [SerializeField] private GameObject landingPagePanel = null;

    public void Start()
    {
        //shows specific error messages to indicate issues
        if(networkManager == null)
        {
            Debug.LogError("networkManager not attached to MainMenu");
        }

        if(landingPagePanel == null)
        {
            Debug.LogError("landingPagePanel not attached to MainMenu");
        }
    }

    public void HostLobby()
    {
        //makes you the host of the lobby
        networkManager.StartHost();
        //deactivates the landing page panel
        landingPagePanel.SetActive(false);
    }

}

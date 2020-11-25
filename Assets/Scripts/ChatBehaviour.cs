using Mirror;
using System;
using TMPro;
using UnityEngine;


public class ChatBehaviour : NetworkBehaviour
{
    /// <summary>
    /// this script allows you to chat to various people
    /// </summary>
    //creates a chatUI
    [SerializeField] private GameObject chatUI = null;
    //creates a Text called chat text
    [SerializeField] private TMP_Text chatText = null;
    //creates an input field
    [SerializeField] private TMP_InputField inputField = null;
    //creates an event called onmessage
    private static event Action<string> OnMessage;

    //overrides the starting authority in network behaviour
    public override void OnStartAuthority()
    {
        //sets the chatui active
        chatUI.SetActive(true);
        //adds a new message to the onmessage
        OnMessage += HandleNewMessage;
    }

    [ClientCallback]
    private void OnDestroy()
    {
        //takes away a message if you don't have authority
        if (!hasAuthority) { return; }

        OnMessage -= HandleNewMessage;
    }

    private void HandleNewMessage(string message)
    {
        //adds the message to the chat text
        chatText.text += message;
    }

    [Client]
    public void Send(string message)
    {

        if (!Input.GetKeyDown(KeyCode.Return)) { return; }

        if (string.IsNullOrWhiteSpace(message)) { return; }

        CmdSendMessage(message);

        inputField.text = string.Empty;
    }

    [Command]
    private void CmdSendMessage(string message)
    {
        RpcHandleMessage($"[{connectionToClient.connectionId}]: {message}");
    }

    [ClientRpc]
    private void RpcHandleMessage(string message)
    {
        OnMessage?.Invoke($"\n{message}");
    }
}
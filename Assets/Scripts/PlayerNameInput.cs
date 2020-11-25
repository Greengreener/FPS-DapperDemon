using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PlayerNameInput : MonoBehaviour
{
    //Creates a input field called name input field
    [Header("UI")]
    [SerializeField] private TMP_InputField nameInputField = null;
    //desiginates a button called continue button-

    [SerializeField] private Button continueButton = null;

    //sets string called display name
    public static string DisplayName { get; private set; }
    //sets a sting called player prefs name key called player name
    private string PlayerPrefsNameKey = "PlayerName";

    private void Start()
    {
        //sets up the input field
        SetUpInputField();
        //creates log error if problems occur
        if(nameInputField == null)
        {
            Debug.LogError("nameInputField is not attached to PlayerNameInput");
        }
        if (continueButton == null)
        {
            Debug.LogError("continueButton is not attached to PlayerNameInput");
        }
    }

    private void SetUpInputField()
    {
        //makes the continue button not interactable
        if (!PlayerPrefs.HasKey(PlayerPrefsNameKey))
        {
            continueButton.interactable = false;
            return;
        }
        //sets the player name based on player prefs
        string defaultName = PlayerPrefs.GetString(PlayerPrefsNameKey);

        nameInputField.text = defaultName;

        SetPlayerName(defaultName);
    }

    public void SetPlayerName(string name)
    {
        
        continueButton.interactable = !string.IsNullOrEmpty(name);
    }

    public void SavePlayerName()
    {
        //save ths player name for the future
        DisplayName = nameInputField.text;

        PlayerPrefs.SetString(PlayerPrefsNameKey, DisplayName);
    }
}

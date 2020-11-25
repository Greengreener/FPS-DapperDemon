using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Audio;


public class Setting : MonoBehaviour
{
    // create a public static bool called SettingsOpen
    public static bool SettingsOpen;
    //allows you to set the sound right
    // create an AudioMixer called audioMixer
    public AudioMixer audioMixer;
    //create a public gameObject called Settings 
    public GameObject Settings;
    //create a public Dropdown called resolutionDropDown
    public Dropdown resolutionDropDown;
    //create an array for different resolution options called resolutions
    Resolution[] resolutions;
    // Start is called before the first frame update
    //public KeyBinds[] keys;
    //create a struture called KeyBinds and include a string called name and a KeyCode called key
    struct KeyBinds
    {
        public string name;
        public KeyCode key;
    };
    //allows you to set what kind of keys you use to do various things
    // create a public Text for keyButtons, forwardButton and backwardButton
    public Text keyButtons;
    public Text forwardButton, backwardButton;
    //create a public KeyCode called forward, backward and tempKey
    public KeyCode forward, backward, tempKey;
    //create a private function that works at the start of the scene
    void Start()
    {

        //sets the defaults
        //set SettingsOpen to false
        SettingsOpen = false;
        //set forward to Forward with input W in the Keycode System
        forward = (KeyCode)System.Enum.Parse(typeof(KeyCode), PlayerPrefs.GetString("Forward", "W"));
        //set forwardButton text to forward by converting to string
        forwardButton.text = forward.ToString();
        //set backward to Backward with input S in the Keycode System
        backward = (KeyCode)System.Enum.Parse(typeof(KeyCode), PlayerPrefs.GetString("Backward", "S"));
        //set backwardButton text to backward by converting to string
        backwardButton.text = backward.ToString();
        //set resolutions to the Screen resolution
        resolutions = Screen.resolutions;
        //ClearOptions in the resolutionDropDown
        resolutionDropDown.ClearOptions();
        //create a string list called options
        List<string> options = new List<string>();
        //set currentResolution index to 0
        int currentResolutionIndex = 0;
        // for each resolution add an option and alter the dropDown width and height
        for (int i = 0; i < resolutions.Length; i++)
        {
            string option = resolutions[i].width + " x " + resolutions[i].height;
            options.Add(option);

            if (resolutions[i].width == Screen.currentResolution.width && resolutions[i].height == Screen.currentResolution.height)
            {
                currentResolutionIndex = 1;
            }

        }
        //Add options to the resolutionDropDown
        resolutionDropDown.AddOptions(options);
        //set the resolution calue to the currentResolutionIndex
        resolutionDropDown.value = currentResolutionIndex;
        //Refresh the value of the resolutionDropDown
        resolutionDropDown.RefreshShownValue();


    }
    private void SetKeyCode()
    {

        //create an event called e and set it to current event
        Event e = Event.current;

        //tempKey = e.keyCode;
        //if forward does not have a keycode and e.keycode does not equal backward then set forward to e.keycode and set fowardButton text to forward
        //if forward does not have a keycode and e.keycode does equal backward then set forward to tempKey and set fowardButton text to forward
        if (forward == KeyCode.None)
        {
            //if keycode does not equal backward
            if (e.keyCode != backward)
            {
                //make forward equal to e keycode and deisplay text
                forward = e.keyCode;
                forwardButton.text = forward.ToString();

            }
            else
            {
                //make forward the tempKey
                forward = tempKey;
                forwardButton.text = forward.ToString();
            }


        }
        //if backward does not have a keycode and e.keycode does not equal forward then set backward to e.keycode and set backwardButton text to backward
        //if backward does not have a keycode and e.keycode does equal forward then set backward to tempKey and set backwardButton text to backward
        if (backward == KeyCode.None)
        {
            if (e.keyCode != forward)
            {
                backward = e.keyCode;
                backwardButton.text = backward.ToString();
            }
            else
            {
                backward = tempKey;
                backwardButton.text = backward.ToString();
            }
        }


    }
    //create a public function called Forward
    public void Forward()
    {
        //allows you to change Forward keycode to none
        //if backward is not None 
        if (backward != KeyCode.None)
        {

            tempKey = forward;
            forward = KeyCode.None;
        }
        forwardButton.text = forward.ToString();

    }
    public void Backward()
    {
        //allows you to change Backward keycode to none
        //if forward is not None 
        if (forward != KeyCode.None)
        {

            tempKey = backward;
            backward = KeyCode.None;
        }
        backwardButton.text = backward.ToString();

    }
    //create a public function called SetVolume with a volume float
    public void SetVolume(float volume)
    {
        //allows you to set the volume in the main menu
        Debug.Log(volume);
        //set the float in the audioMixer to the volume on the function
        audioMixer.SetFloat("volume", volume);
    }
    //create a public function called SetFullScreen with a isFullsceen bool
    public void SetFullscreen(bool isFullscreen)
    {
        //allows you to decide whether you are in the fullscreen
        //set the fullscreen to the bool in the function
        Screen.fullScreen = isFullscreen;
    }
    //create a public function called SetQuality with an int called qualityIndex 
    public void SetQuality(int qualityIndex)
    {
        //allows you to choose from an index of qualities
        //setQualityLevel in quality settings to the qualityIndex in the function
        QualitySettings.SetQualityLevel(qualityIndex);
    }
    //create a public function called SetResolution with an int called resolutionIndex
    public void SetResolution(int resolutionIndex)
    {
        //allows you to set the resolution from an index
        //set resolution to the resolutions based on the resolutionindex
        Resolution resolution = resolutions[resolutionIndex];
        //alter the screen based on the resolution width and height
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreen);
    }

    //create a public function called OpenSettings
    public void OpenSettings()
    {
        //if SettingsOpen is false then set to true and make Settings gameobject active
        if (!SettingsOpen)
        {
            Settings.SetActive(true);
            SettingsOpen = true;
        }
        //if SettingsOpen is true then set to false and make Settings gameobject not active
        else if (SettingsOpen)
        {
            Settings.SetActive(false);
            SettingsOpen = false;
        }
    }
    //create a public function called Update
    //if SettingsOpen is true then change timeScale to 0 otherwise set it to 1
    void OnGUI()
    {
        // activate the SetKeyCode function
        SetKeyCode();
        //changes timescale based on whther the setting is open
        if (SettingsOpen)
        {
            Time.timeScale = 0;
        }
        else if (!SettingsOpen)
        {
            Time.timeScale = 1;
        }
    }
}

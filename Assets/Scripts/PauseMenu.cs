using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMenu : MonoBehaviour
{
    //create a static bool called isPaused
    public static bool isPaused = false;
    //create a gameObject called _pauseMenu
    public GameObject _pauseMenu;
    // Start is called before the first frame update


    // Update is called once per frame
    private void Update()
    {
        //if you press the escape button
        //activate the TogglePause function
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            TogglePause();
        }
    }
    //create a function called TogglePause
    public void TogglePause()
    {
        //if its paused
        //make _pauseMenu inactive, set isPaused to false, make timeScale normal, lock the mouse cursor and make it invisible
        if (isPaused)
        {
            Time.timeScale = 1;
            _pauseMenu.SetActive(false);
            Cursor.lockState = CursorLockMode.Locked; // lock the mouse cursor
            Cursor.visible = false;
            isPaused = false;
            return;

        }
        //if not paused
        //make _pauseMenu active, set isPaused to true, make timeScale zero, unlock the mouse cursor and make it visible
        else
        {
            Time.timeScale = 0;
            Cursor.lockState = CursorLockMode.None; // lock the mouse cursor
            Cursor.visible = true;
            _pauseMenu.SetActive(true);
            isPaused = true;
            return;
        }
    }
}

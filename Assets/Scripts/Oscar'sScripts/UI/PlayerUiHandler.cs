using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerUiHandler : MonoBehaviour
{
    #region ScriptRefs
    Health player;

    #endregion
    #region Variables
    [Header("UiElements")]
    [SerializeField]
    Slider healthSlider;

    #endregion
    void Start()
    {
        player = GetComponentInParent<Health>();


        //healthSlider.maxValue = player.healthTotal;
        //healthSlider.value = player.HealthCurrent;

    }
}

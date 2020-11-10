using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GunUiHandler : MonoBehaviour
{
    Gun currentGun;
    Inventory playerInv;

    [SerializeField]
    Text gunTypeName;
    [SerializeField]
    Text clipAmmo;
    [SerializeField]
    Text bagAmmo;
    int currentGunCode  = 0;
    void Start()
    {
        playerInv = GetComponentInParent<Inventory>();
        currentGun = this.GetComponent<Gun>();
        SetCurrentGunUI();
    }
    void LateUpdate()
    {
        SetCurrentGunUI();
    }
    void SetCurrentGunUI()
    {
        gunTypeName.text = currentGun.GunType;
        clipAmmo.text = currentGun.ammoClipCurrent.ToString();
        currentGunCode = currentGun.GunCode;
        switch (currentGunCode)
        {
            case 1:
                bagAmmo.text = playerInv.handgunAmmoCurrent.ToString();
                break;
            case 2:
                bagAmmo.text = playerInv.rifleAmmoCurrent.ToString();
                break;
        }
    }
}

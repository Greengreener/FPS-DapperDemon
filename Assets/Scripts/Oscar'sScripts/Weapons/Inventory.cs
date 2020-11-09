using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    #region Gun ammo
    [SerializeField]
    public int handgunAmmoCurrent;
    int handgunAmmoCapacity = 30;
    [SerializeField]
    public int rifleAmmoCurrent;
    int rifleAmmoCapacity = 150;
    #endregion
    [SerializeField]
    public int grenadeCurrent;
    int grenadeCapacity = 3;
    private void Awake()
    {
        RestAmmo();
    }
    public int ReloadCurrentGun(int _GunCode, int _spaceInClip)
    {
        int ammoIntoClip = 0;
        switch (_GunCode)
        {
            case 1: //Handgun
                if (handgunAmmoCurrent < _spaceInClip)
                {
                    ammoIntoClip = handgunAmmoCurrent;
                    handgunAmmoCurrent = 0;
                }
                else
                {
                    handgunAmmoCurrent -= _spaceInClip;
                    ammoIntoClip = _spaceInClip;
                }
                break;
            case 2: //Rifle
                if (rifleAmmoCurrent < _spaceInClip)
                {
                    ammoIntoClip = rifleAmmoCurrent;
                    rifleAmmoCurrent = 0;
                }
                else
                {
                    rifleAmmoCurrent -= _spaceInClip;
                    ammoIntoClip = _spaceInClip;
                }
                break;
        }
        return ammoIntoClip;
    }
    public void AddAmmoToInv(int ammoTypeCode, int _ammoPickedUp)
    {
        var spaceLeftInBag = 0;
        switch (ammoTypeCode)
        {
            case 1: //Handgun                
                if (handgunAmmoCurrent == handgunAmmoCapacity) { return; }
                spaceLeftInBag = handgunAmmoCapacity - handgunAmmoCurrent;
                if (_ammoPickedUp > spaceLeftInBag)
                {
                    handgunAmmoCurrent = handgunAmmoCapacity;
                }
                else
                {
                    handgunAmmoCurrent += _ammoPickedUp;
                }
                break;
            case 2: //Rifle

                if (rifleAmmoCurrent == rifleAmmoCapacity) { return; }
                spaceLeftInBag = rifleAmmoCapacity - rifleAmmoCurrent;
                if (_ammoPickedUp > spaceLeftInBag)
                {
                    rifleAmmoCurrent = rifleAmmoCapacity;
                }
                else
                {
                    rifleAmmoCurrent += _ammoPickedUp;
                }
                break;
        }
    }
    public void UseGrenade()
    {
        grenadeCurrent--;
    }
    public void ResetAmmo()
    {
        handgunAmmoCurrent = handgunAmmoCapacity;
        rifleAmmoCurrent = rifleAmmoCapacity;
        grenadeCurrent = grenadeCapacity;
    }
}
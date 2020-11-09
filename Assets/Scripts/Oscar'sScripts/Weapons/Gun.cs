using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : MonoBehaviour
{
    [SerializeField]
    Health player;
    [SerializeField]
    Inventory inv;
    public int GunCode;
    [SerializeField]
    public string GunType = "";
    public float Damage;
    float fireRate;
    [SerializeField]
    public int ammoClipCurrent;
    int ammoClipCapacity;
    float gunRange;
    Camera playerCamera;
    void Awake()
    {
        player = gameObject.GetComponentInParent<Health>();
        inv = gameObject.GetComponentInParent<Inventory>();
        playerCamera = gameObject.GetComponentInParent<Camera>();
        #region GunTypeSetting
        ResetGun();
        #endregion
    }
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Shoot();
        }
        if (Input.GetKeyDown(KeyCode.R))
        {
            Reload();
        }
    }
    void Shoot()
    {
        if (ammoClipCurrent > 0)
        {
            RaycastHit hit;
            if (Physics.Raycast(playerCamera.transform.position, playerCamera.transform.forward, out hit, gunRange))
            {
                Health target = hit.transform.GetComponent<Health>();
                if (target != null && target.teamTag != player.teamTag)
                {
                    //print("Target found ");
                    target.Damage(Damage);
                }
            }
            ammoClipCurrent--;
        }
        else { return; }
    }

    /// <summary>
    /// Reloading summary
    /// </summary>
    void Reload()
    {
        //inv.ammo -= ammoClipCapacity;
        //ammoClipCurrent = ammoClipCapacity;
        var spaceInClip = ammoClipCapacity - ammoClipCurrent;
        ammoClipCurrent += inv.ReloadCurrentGun(GunCode, spaceInClip);
    }
    public void ResetGun()
    {
        switch (GunCode)
        {
            case 1: //HandGun
                GunType = "Handgun";
                Damage = 2.5f;
                fireRate = 1;
                gunRange = 10;
                ammoClipCapacity = 8;
                ammoClipCurrent = ammoClipCapacity;
                break;
            case 2: //Rifle
                GunType = "Rifle";
                Damage = 10;
                fireRate = 2.5f;
                gunRange = 20;
                ammoClipCapacity = 30;
                ammoClipCurrent = ammoClipCapacity;
                break;
        }
    }
}
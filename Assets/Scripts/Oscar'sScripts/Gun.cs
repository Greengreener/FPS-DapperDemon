using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : MonoBehaviour
{
    [SerializeField]
    Health player;
    Inventory inventory;
    public int GunCode;
    [SerializeField]
    string GunType;
    public float damage;
    float fireRate;
    int ammoClipCurrent;
    int ammoClipCapacity;
    float gunRange;
    Camera playerCamera;
    void Start()
    {
        player = gameObject.GetComponentInParent<Health>();
        inventory = gameObject.GetComponent<Inventory>();
        playerCamera = gameObject.GetComponentInParent<Camera>();
        #region GunTypeSetting
        switch (GunCode)
        {
            case 0: //HandGun
                GunType = "Handgun";
                damage = 2.5f;
                fireRate = 1;
                gunRange = 10;
                ammoClipCapacity = 8;
                ammoClipCurrent = ammoClipCapacity;
                break;
            case 1: //Rifle
                GunType = "Rifle";
                damage = 10;
                fireRate = 2.5f;
                gunRange = 20;
                ammoClipCapacity = 30;
                ammoClipCurrent = ammoClipCapacity;
                break;
        }
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
            Reload(ammoClipCurrent);
        }
    }

    void Shoot()
    {
        RaycastHit hit;
        if (Physics.Raycast(playerCamera.transform.position, playerCamera.transform.forward, out hit, gunRange))
        {
            #region Debugging
            // Debug.DrawLine(playerCamera.transform.position, playerCamera.transform.forward * gunRange, Color.green, 100f);
            // print("Bang");
            #endregion

            Health target = hit.transform.GetComponent<Health>();
            if (target != null && target.teamTag != player.teamTag)
            {
                //print("Target found ");
                target.Damage(damage);
            }

        }

    }
    int Reload(int _ammoClipCurrent)
    {
        int ammoInClip = 0;



        return ammoInClip;
    }
}

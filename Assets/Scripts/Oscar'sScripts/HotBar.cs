using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HotBar : MonoBehaviour
{
    Inventory inv;
    [SerializeField]
    List<Gun> guns;
    [SerializeField]
    int currentGunId = 0;
    void Awake()
    {
        inv = gameObject.GetComponent<Inventory>();
        guns = new List<Gun>(gameObject.GetComponentsInChildren<Gun>());
        for (int i = 0; i < guns.Count; i++)
        {
            guns[i].gameObject.SetActive(false);
        }
        guns[0].gameObject.SetActive(true);
    }
    void Update()
    {

        if (Input.mouseScrollDelta.y == 1)
        {
            print(Input.mouseScrollDelta.y);
            currentGunId++;

            if (currentGunId > guns.Count) currentGunId = 0;
            if (currentGunId < 0) currentGunId = guns.Count;

            WeaponChange(currentGunId);
        }
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            WeaponChange(0);
            currentGunId = 0;
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            WeaponChange(1);
            currentGunId = 1;
        }
    }
    void WeaponChange(int _gunCode)
    {
        for (int i = 0; i < guns.Count; i++)
        {
            guns[i].gameObject.SetActive(false);
        }
        guns[_gunCode].gameObject.SetActive(true);

    }
}

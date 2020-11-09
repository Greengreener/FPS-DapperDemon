using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrenadeThrow : MonoBehaviour
{
    [SerializeField]
    Inventory inv;
    [SerializeField]
    Transform throwPosition;
    [SerializeField]
    GameObject grenadePrefab;
    void Start()
    {
        inv = GetComponent<Inventory>();
        print(inv.grenadeCurrent);
    }
    void Update()
    {
        if (inv.grenadeCurrent >= 1 && Input.GetKeyDown(KeyCode.G))ThrowGrenade();
    }
    void ThrowGrenade()
    {
        print("testSide1");
        Instantiate(grenadePrefab, throwPosition.transform.position, throwPosition.transform.rotation);
        inv.UseGrenade();
        print("testSide2");
    }
}
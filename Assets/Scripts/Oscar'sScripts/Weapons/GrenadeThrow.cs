using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrenadeThrow : MonoBehaviour
{
    Inventory inv;
    Transform throwPosition;
    Transform throwForwardPosition;
    GameObject grenadePrefab;
    void Start()
    {
        inv = GetComponent<Inventory>();
    }
    void Update()
    {
        if (inv.grenadeCurrent < 0 && Input.GetKeyDown(KeyCode.G)) ThrowGrenade();
    }
    void ThrowGrenade()
    {
        Instantiate(throwPosition, throwPosition);
    }
}

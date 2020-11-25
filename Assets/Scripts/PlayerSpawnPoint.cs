using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public class PlayerSpawnPoint : MonoBehaviour
{
    /// <summary>
    /// this script makes the spawn point connect to spawn system
    /// </summary>
    //bool shwoing what team you are on
    public bool TeamID;
    private void Awake()
    {
        //adds spawnpoint to spawn system
        PlayerSpawnSystem.AddSpawnPoint(transform);
    }

    private void OnDestroy()
    {
        //removes spawnpoint from spawn system
        PlayerSpawnSystem.RemoveSpawnPoint(transform);
    }

    private void OnDrawGizmos()
    {
        //adds gizmo to the situations
        Gizmos.color = Color.blue;
        Gizmos.DrawSphere(transform.position, 0.3f);
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.position + transform.forward * 1f);
    }
}

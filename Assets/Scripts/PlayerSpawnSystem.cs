using Mirror;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Serialization;
using UnityEngine;

public class PlayerSpawnSystem : NetworkBehaviour
{
    [SerializeField] private GameObject[] playerPrefab = null;
    private int[] Team;
    private static List<Transform> spawnPoints = new List<Transform>();
    private static List<Transform> spawnPoints1 = new List<Transform>();
    private int firstnextIndex = 0, secondnextIndex = 0;
    private int teamtracker = 1;
    public static void AddSpawnPoint(Transform spawnTransform)
    {
        if (spawnTransform.GetComponent<PlayerSpawnPoint>().TeamID == true)
        {
            spawnPoints.Add(spawnTransform);

            spawnPoints = spawnPoints.OrderBy(x => x.GetSiblingIndex()).ToList();
        }
        else
        {
            spawnPoints1.Add(spawnTransform);

            spawnPoints1 = spawnPoints1.OrderBy(x => x.GetSiblingIndex()).ToList();
        }
        
    }

    public static void RemoveSpawnPoint(Transform spawnTransform)
    {
        if (spawnTransform.GetComponent<PlayerSpawnPoint>().TeamID == true)
        {
            spawnPoints.Remove(spawnTransform);

            
        }
        else
        {
            spawnPoints1.Remove(spawnTransform);

            
        }
        
    }

    public override void OnStartServer()
    {
        NetworkManagerLobby.onServerReadied += SpawnPlayer;
    }

    [ServerCallback]
    private void OnDestroy()
    {
        NetworkManagerLobby.onServerReadied -= SpawnPlayer;
    }

    [Server]
    public void SpawnPlayer(NetworkConnection conn)
    {

        if (teamtracker == 1)
        {


            Transform spawnPoint = spawnPoints.ElementAtOrDefault(firstnextIndex);
            
              
               
            
            if (spawnPoint == null)
            {
                Debug.LogError("Missing spawn point for player" + firstnextIndex);
                return;
            }




            GameObject playerInstance = Instantiate(playerPrefab[0], spawnPoint.position, spawnPoint.rotation);
            NetworkServer.Spawn(playerInstance, conn);
            teamtracker = 2;
            firstnextIndex++;
        }

        else
        {
            Transform spawnPoint = spawnPoints.ElementAtOrDefault(secondnextIndex);

            if (spawnPoint == null)
            {
                Debug.LogError("Missing spawn point for player" + secondnextIndex);
                return;
            }
           

                GameObject playerInstance = Instantiate(playerPrefab[1], spawnPoint.position, spawnPoint.rotation);
                NetworkServer.Spawn(playerInstance, conn);
            teamtracker = 1;
            secondnextIndex++;

            
        }
        
        





    }

}

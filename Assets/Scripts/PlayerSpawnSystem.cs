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
    private int nextIndex = 0;

    public static void AddSpawnPoint(Transform spawnTransform)
    {
        spawnPoints.Add(spawnTransform);

        spawnPoints = spawnPoints.OrderBy(x => x.GetSiblingIndex()).ToList();
    }

    public static void RemoveSpawnPoint(Transform spawnTransform) => spawnPoints.Remove(spawnTransform);

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


        if (Team[0] < Team[1])
        {
            Transform spawnPoint = spawnPoints.ElementAtOrDefault(nextIndex);
            while (spawnPoint.tag == "TeamA")
            {
                spawnPoint = null;
                spawnPoint = spawnPoints.ElementAtOrDefault(nextIndex);
            }
            if (spawnPoint == null)
            {
                Debug.LogError("Missing spawn point for player" + nextIndex);
                return;
            }
            



                GameObject playerInstance = Instantiate(playerPrefab[0], spawnPoint.position, spawnPoint.rotation);
                NetworkServer.Spawn(playerInstance, conn);
                Team[0] += 1;
            
            
        }
        else
        {
            Transform spawnPoint = spawnPoints.ElementAtOrDefault(nextIndex);

            if (spawnPoint == null)
            {
                Debug.LogError("Missing spawn point for player" + nextIndex);
                return;
            }
            if (spawnPoint.tag != "TeamA")
            {


                GameObject playerInstance = Instantiate(playerPrefab[1], spawnPoint.position, spawnPoint.rotation);
                NetworkServer.Spawn(playerInstance, conn);
                Team[1] += 1;
            }
        }
        
        nextIndex++;





    }

}

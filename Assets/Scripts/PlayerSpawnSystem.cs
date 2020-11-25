using Mirror;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Serialization;
using UnityEngine;

public class PlayerSpawnSystem : NetworkBehaviour
{
    //adds an array for the player prefabs
    [SerializeField] private GameObject[] playerPrefab = null;
    //allows you to desiginate number of teams
    private int[] Team;
    //creates a list of spawn points for the first team and the second
    private static List<Transform> spawnPoints = new List<Transform>();
    private static List<Transform> spawnPoints1 = new List<Transform>();
    //ints to measure number of people on the two teams
    private int firstnextIndex = 0, secondnextIndex = 0;
    private int teamtracker = 1;
    public static void AddSpawnPoint(Transform spawnTransform)
    {
        //adds spawn points to list based on their team id
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
        //removes spawn points from the list based pn their team id
        if (spawnTransform.GetComponent<PlayerSpawnPoint>().TeamID == true)
        {
            spawnPoints.Remove(spawnTransform);

            
        }
        else
        {
            spawnPoints1.Remove(spawnTransform);

            
        }
        
    }
    //spawns a player when the game begins
    public override void OnStartServer()
    {
        NetworkManagerLobby.onServerReadied += SpawnPlayer;
    }

    [ServerCallback]
    //despawns a player when the game ends
    private void OnDestroy()
    {
        NetworkManagerLobby.onServerReadied -= SpawnPlayer;
    }

    [Server]
    //respawns the player at a spawnpoint based on team id
    public void RespawnPlayer(GameObject self)
    {

        if (teamtracker == 1)
        {


            Transform spawnPoint = spawnPoints.ElementAtOrDefault(firstnextIndex);




            if (spawnPoint == null)
            {
                Debug.LogError("Missing spawn point for player" + firstnextIndex);
                return;
            }




            self.transform.position = spawnPoint.position;
            
            teamtracker = 2;
            firstnextIndex++;
        }

        else
        {
            Transform spawnPoint = spawnPoints1.ElementAtOrDefault(secondnextIndex);

            if (spawnPoint == null)
            {
                Debug.LogError("Missing spawn point for player" + secondnextIndex);
                return;
            }


            self.transform.position = spawnPoint.position;
            teamtracker = 1;
            secondnextIndex++;


        }







    }
    //spawns a player at the start of the game
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
            playerInstance.GetComponent<Health>();
            NetworkServer.Spawn(playerInstance, conn);
            teamtracker = 2;
            firstnextIndex++;
        }

        else
        {
            Transform spawnPoint = spawnPoints1.ElementAtOrDefault(secondnextIndex);

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

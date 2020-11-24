using System.Collections;
using UnityEngine;
using UnityEngine.TestTools;
using NUnit.Framework;

public class NetworkSuite 
{
    private Movement movement;

    [SetUp]
    public void Setup()
    {
        GameObject movementGameObject = MonoBehaviour.Instantiate(Resources.Load<GameObject>("Prefabs/Movement"));
        movement = movementGameObject.GetComponent<Movement>();

    }

    [UnityTest]
    public IEnumerator AstroidMoveDown()
    {
        GameObject asteroid = movement.GetSpawner().SpawnAsteroid();
        float initialYPos = asteroid.transform.position.y;

        yield return new WaitForSeconds(0.1f);

        Assert.Less(asteroid.transform.position.y, initialYPos);
    }

    [TearDown]
    public void TearDown()
    {
        Object.Destroy(movement.gameObject);
    }
    [UnityTest]
    public IEnumerator GameOverOccursOnAsteroidCollision()
    {
        GameObject asteroid = movement.GetSpawner().SpawnAsteroid();
        asteroid.transform.position = movement.GetShip().transform.position;

        yield return new WaitForSeconds(0.1f);
        Assert.True(movement.isGameOver);
    }
    [UnityTest]
    public IEnumerator NewGameRestartsGame()
    {
        movement.isGameOver = true;
        movement.NewGame();


        Assert.False(movement.isGameOver);
        yield return null;
    }
}

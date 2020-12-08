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
        GameObject movementGameObject = MonoBehaviour.Instantiate(Resources.Load<GameObject>("Player1"));
        movement = movementGameObject.GetComponent<Movement>();

    }

    [TearDown]
    public void Teardown()
    {
        Object.Destroy(movement.gameObject);
    }
    //test one, can you change movedir
    //test two, does move dir alter the position of the player
    //test three, does jump add force to character controller

    
    [UnityTest]
    public IEnumerator ChangeMove()
    {
        movement.gameObject.SetActive(true);
        Vector3 originalMoveDir = movement._moveDir;
        movement._moveDir -= movement.transform.right;

        Assert.True(originalMoveDir != movement._moveDir);

        yield return null;
    }
    [UnityTest]
    public IEnumerator ChangePos()
    {
        movement.gameObject.SetActive(true);
        Vector3 originalPos = movement.transform.position;
        movement._moveDir -= movement.transform.right;
        //movement.Move();

        yield return new WaitForSeconds(0.1f);

        Assert.True(originalPos != movement.transform.position);

    }
    [UnityTest]
    public IEnumerator JumpUp()
    {
        movement.gameObject.SetActive(true);
        Vector3 originalPos = movement.transform.position;
        movement.Jump();

        yield return new WaitForSeconds(0.1f);

        Assert.True(originalPos.y != movement.transform.position.y);
    }

}

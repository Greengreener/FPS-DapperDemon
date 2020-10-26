using UnityEngine;
using UnityEngine.UI;
using Mirror;

public class Movement : NetworkBehaviour
{
    [Header("Speed Vars")]
    //value Variables
    public float moveSpeed, rotateSpeed;
    public float walkSpeed, runSpeed;

    //Struct - Contains Multiple Variables (eg...3 floats)
    private Vector3 _moveDir;
    //Reference Variable

    public CharacterController _charC;
    public GameObject self;


    private void Start()
    {
        _charC = GetComponent<CharacterController>();




    }

    private void Update()
    {

        if (hasAuthority)
        {
            Move();
        }
       



    }

    private void Move()
    {
           //set speed







            if (Input.GetKeyDown("e"))
            {
                moveSpeed = runSpeed;

            }
            else if (Input.GetKeyDown("q"))
            {
                moveSpeed = 0;

            }
            else
            {
                moveSpeed = walkSpeed;

            }
        
        _moveDir = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")) * moveSpeed;
        
        Vector3 newDirection = Vector3.RotateTowards(transform.forward, _moveDir, rotateSpeed, 0.0f);
        self.transform.rotation = Quaternion.LookRotation(newDirection);
        _charC.Move(_moveDir * Time.deltaTime);








    }
}

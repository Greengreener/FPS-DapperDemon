using Mirror;
using UnityEngine;
using UnityEngine.UI;

public class Movement : NetworkBehaviour
{
    /// <summary>
    /// this scripts lets you move the player around
    /// </summary>
    [Header("Speed Vars")]
    //value Variables
    //set how fawst you can move and rotate
    public float moveSpeed, rotateSpeed;
    //sets how fast you can walk and run
    public float walkSpeed, runSpeed;
    //controls how fast you fall and how high can you jump
    public float gravity, jumpForce;
    //Struct - Contains Multiple Variables (eg...3 floats)
    //controls where your character goes
    [HideInInspector]
    public Vector3 _moveDir;
    //Reference Variable
    [SerializeField]
    //bool that lets you move without going to lobby
    private bool forceMovement = false;
    // character controller for moving the person
    public CharacterController _charC;
    //sets what the player is
    public GameObject self;
    //connects to the player health
    public Health playerHealth;
    //sets how much fall damage you get
    public float fallDamage = 1;

    private void Start()
    {
        //sets charecter controller
        _charC = GetComponent<CharacterController>();
        //sets player health
        playerHealth = gameObject.GetComponent<Health>();
    }

    private void Update()
    {
        //allows you to control player under certain conditions
        if (hasAuthority || forceMovement)
        {
            //moves the player
            Move();
        }

    }
    public void Jump()
    {
        _charC.Move(new Vector3(0, jumpForce, 0));
    }
  public void Move()
    {
        //set speed
        //makes you run when you move
        if (Input.GetKeyDown("e"))
        {
            moveSpeed = runSpeed;

        }
        //makes you stop when you crouch
        else if (Input.GetKeyDown("q"))
        {
            moveSpeed = 0;

        }
        else
        {
            moveSpeed = walkSpeed;

        }
        //the player jumps when you press j
        if (Input.GetKeyDown("j") && _charC.isGrounded == true)
        {
            Jump();
        }

        else
        {
            //the player falls to the ground at an accelerating rate
            if (_charC.isGrounded == false)
            {
                gravity += Time.deltaTime * Time.deltaTime * 9.8f;
            }
            else
            {
                //makes the player get hburt when hitting the ground hard enough
                if (gravity >= 1)
                {
                    Debug.Log("Player is hurt");
                    playerHealth.Damage(fallDamage);
                    gravity = 0.7f;
                }
             
                else
                {
                    gravity = 0.7f;
                }

            }

        }
        //sets the horizontal and vertical to the input
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        //_moveDir = new Vector3(horizontal, -gravity * 2f, vertical) * moveSpeed;
        //transform the vertical and horizontal into a vector3
        Vector3 forward = transform.forward * vertical;
        Vector3 right = transform.right * horizontal;
        //combines the vertical and horizontal vectors into a single vector3
        _moveDir = (forward + right) * moveSpeed;
        //adds gravity to the move dir
        _moveDir.y = -gravity * 2f;

        //Vector3 newDirection = Vector3.RotateTowards(transform.forward, _moveDir, rotateSpeed, 0.0f);
        //self.transform.rotation = Quaternion.LookRotation(newDirection);
        // player moves in the direction of the move direction
        _charC.Move(_moveDir * Time.deltaTime);

    }
}
using Mirror;
using UnityEngine;
using UnityEngine.UI;

public class Movement : NetworkBehaviour
{
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
    private Vector3 _moveDir;
    //Reference Variable
    [SerializeField]
    private bool forceMovement = false;

    public CharacterController _charC;
    public GameObject self;

    public Health playerHealth;
    public float fallDamage = 1;

    private void Start()
    {
        _charC = GetComponent<CharacterController>();
        playerHealth = gameObject.GetComponent<Health>();
    }

    private void Update()
    {

        if (hasAuthority || forceMovement)
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

        if (Input.GetKeyDown("j") && _charC.isGrounded == true)
        {
            _charC.Move(new Vector3(0, jumpForce, 0));
        }

        else
        {
            if (_charC.isGrounded == false)
            {
                gravity += Time.deltaTime * Time.deltaTime * 9.8f;
            }
            else
            {
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
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        //_moveDir = new Vector3(horizontal, -gravity * 2f, vertical) * moveSpeed;
        Vector3 forward = transform.forward * vertical;
        Vector3 right = transform.right * horizontal;
        _moveDir = (forward + right) * moveSpeed;
        _moveDir.y = -gravity * 2f;

        //Vector3 newDirection = Vector3.RotateTowards(transform.forward, _moveDir, rotateSpeed, 0.0f);
        //self.transform.rotation = Quaternion.LookRotation(newDirection);
        _charC.Move(_moveDir * Time.deltaTime);

    }
}
﻿using UnityEngine;
using UnityEngine.UI;
using Mirror;

public class Movement : NetworkBehaviour
{
    [Header("Speed Vars")]
    //value Variables
    public float moveSpeed, rotateSpeed;
    public float walkSpeed, runSpeed;
    public float gravity, jumpForce;
    //Struct - Contains Multiple Variables (eg...3 floats)
    private Vector3 _moveDir;
    //Reference Variable
    [SerializeField]
    private bool forceMovement = false;

    public CharacterController _charC;
    public GameObject self;

    
    private void Start()
    {
        _charC = GetComponent<CharacterController>();




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
            gravity = -jumpForce;
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
                    gravity = 0.7f;
                }
                else
                {
                    gravity = 0.7f;
                }
               
            }
            
        }
        _moveDir = new Vector3(Input.GetAxis("Horizontal"), -gravity * 2f, Input.GetAxis("Vertical")) * moveSpeed;
        
        Vector3 newDirection = Vector3.RotateTowards(transform.forward, _moveDir, rotateSpeed, 0.0f);
        self.transform.rotation = Quaternion.LookRotation(newDirection);
        _charC.Move(_moveDir * Time.deltaTime);








    }
}

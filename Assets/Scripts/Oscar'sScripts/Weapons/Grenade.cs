using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Grenade : MonoBehaviour
{
    [SerializeField]
    Collider[] damagedPlayer;
    [SerializeField]
    float grenadeCountDown = 0;
    [SerializeField]
    float grenadeRange = 0;
    [SerializeField]
    float granadeDamage = 0;
    [SerializeField]
    float throwForce = 0;
    Rigidbody rb;
    Transform throwDirection;
    void Start()
    {
        throwDirection = GetComponentInChildren<Transform>();
        rb = GetComponent<Rigidbody>();
        rb.AddForce(throwDirection.position * -throwForce);

    }
    void Update()
    {
        grenadeCountDown -= Time.deltaTime;
        if (grenadeCountDown <= 0)Explosion();
    }
    void Explosion()
    {
        damagedPlayer = Physics.OverlapSphere(gameObject.transform.position, grenadeRange);
        for (int i = 0; i < damagedPlayer.Length; i++)
        {
            Health health;
            if (damagedPlayer[i].gameObject.GetComponent<Health>())
            {
                health = damagedPlayer[i].gameObject.GetComponent<Health>();
                health.Damage(granadeDamage);
            }
        }
        Destroy(this.gameObject);
    }

    /// <summary>
    /// Unfreezes the Rigidbody rotation
    /// </summary>
    /// <param name="other"></param>
    private void OnCollisionEnter(Collision other)
    {
        rb.constraints = RigidbodyConstraints.None;
    }
}
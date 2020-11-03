using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Melee : MonoBehaviour
{
    Health player;
    BoxCollider meleeHitBox;
    float meleeDamage;
    [SerializeField]
    float meleeTime;
    float meleeTimeTotal = 0.5f;
    bool meleeTimerRunning;
    void Start()
    {
        player = gameObject.GetComponentInParent<Health>();
        meleeHitBox = this.gameObject.GetComponent<BoxCollider>();
        meleeDamage = 50f;
        meleeTime = meleeTimeTotal;
    }
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.V))
        {
            meleeHitBox.enabled = true;
            meleeTimerRunning = true;
        }
        if (meleeTimerRunning)
        {
            meleeTime -= Time.deltaTime;
            if (meleeTime <= 0)
            {
                MeleeTimerDown();
            }
        }
    }
    void MeleeTimerDown()
    {
        meleeHitBox.enabled = false;
        meleeTime = meleeTimeTotal;
        meleeTimerRunning = false;
        return;
    }
    private void OnTriggerEnter(Collider _meleeHitBox)
    {
        Health target = _meleeHitBox.gameObject.GetComponent<Health>();
        if (target.teamTag != player.teamTag)
        {
            MeleeAttack(target);
        }
    }
    void MeleeAttack(Health _target)
    {
        _target.Damage(meleeDamage);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
public class Health : MonoBehaviour
{
    [SerializeField]
    float healthCurrent;
    public float healthTotal;
    public string teamTag;
    public bool firstTeam;
    public float respawnTime;
    public PlayerSpawnSystem spawn;
    public GameObject self;
    void Start()
    {
        if (healthTotal == 0)
        {
            Debug.LogError("Health total = null");
        }
        healthCurrent = healthTotal;
        spawn = FindObjectOfType<PlayerSpawnSystem>();
    }
    public void Respawn()
    {
        this.gameObject.SetActive(true);
        spawn.RespawnPlayer(self);
        healthCurrent = healthTotal;

    }
    public void Heal(float _intakeHeal)
    {
        healthCurrent += _intakeHeal;
        if (healthCurrent >= healthTotal)
        {
            healthCurrent = healthTotal;
        }
    }
    public void Damage(float _intakeDamage)
    {
        healthCurrent -= _intakeDamage;
        if (healthCurrent <= 0)
        {
            Death();
        }
    }
    void Update()
    {
        respawnTime -= Time.deltaTime;
        if (respawnTime == 0)
        {
            Respawn();
        }
    }
    void Death()
    {
        #region Temp
        this.gameObject.SetActive(false);
        respawnTime = 9;
        #endregion
    }
}

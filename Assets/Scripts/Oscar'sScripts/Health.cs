using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    public float HealthCurrent { get; set; }
    [SerializeField]
    float healthCurrent;
    public float healthTotal;
    public string teamTag;
    void Start()
    {
        healthCurrent = healthTotal;
        HealthCurrent = healthCurrent;
    }
    public void Heal(float _intakeHeal)
    {
        healthCurrent += _intakeHeal;
        UpdatePublicHealth();
        if (healthCurrent >= healthTotal)
        {
            healthCurrent = healthTotal;
        }
    }
    public void Damage(float _intakeDamage)
    {
        healthCurrent -= _intakeDamage;
        UpdatePublicHealth();
        if (healthCurrent <= 0)
        {
            Death();
        }
    }
    void Death()
    {
        #region Temp
        this.gameObject.SetActive(false);
        #endregion
    }
    void UpdatePublicHealth()
    {
        HealthCurrent = healthCurrent;
    }
}

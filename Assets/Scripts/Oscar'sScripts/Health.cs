using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    float healthCurrent;
    public float healthTotal;
    void Start()
    {
        if (healthTotal == null)
        {
            Debug.LogError("Health total = null");
        }
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
    }
}

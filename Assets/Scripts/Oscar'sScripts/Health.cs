using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    [SerializeField]
    float healthCurrent;
    public float healthTotal;
    public string teamTag;
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
}

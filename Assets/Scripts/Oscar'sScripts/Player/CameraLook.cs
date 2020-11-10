using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraLook : MonoBehaviour
{
    public enum RotationalAxis
    {
        MouseX,
        MouseY
    }
    [Header("Rotation Variables")]
    public RotationalAxis axis = RotationalAxis.MouseX;
    [Range(0, 200)]
    public float sensetivity = 100;
    public float minY = -60, maxY = 60;
    private float _rotY;

    private Light torch;
    bool torchOnOff;
    void Start()
    {
        //Lock the cursor
        Cursor.lockState = CursorLockMode.Locked;
        //Hide the cursor
        Cursor.visible = false;
        if (GetComponent<Camera>())
        {
            axis = RotationalAxis.MouseY;
        }
        torch = GetComponentInChildren<Light>();
        torch.gameObject.SetActive(false);
        torchOnOff = !torch.gameObject.activeSelf;

    }
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            torch.gameObject.SetActive(torchOnOff);
            torchOnOff = !torchOnOff;
        }
        if (axis == RotationalAxis.MouseX)
        {
            transform.Rotate(0, Input.GetAxis("Mouse X") * sensetivity * Time.deltaTime, 0);
        }
        else
        {
            _rotY += Input.GetAxis("Mouse Y") * sensetivity * Time.deltaTime;
            _rotY = Mathf.Clamp(_rotY, minY, maxY);
            transform.localEulerAngles = new Vector3(-_rotY, 0, 0);
        }

    }
}
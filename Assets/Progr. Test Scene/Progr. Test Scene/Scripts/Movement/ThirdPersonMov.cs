using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThirdPersonMov : MonoBehaviour
{
    public CharacterController playerController;
    public float speed = 6f;
    public Transform cam;
    float turnSmoothVelocity;
    public float turnSmoothTime = 0.1f;
    bool isGrounded;
    Vector3 moveVector;
    float verticalVelosity;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float hor = Input.GetAxisRaw("Horizontal");
        float ver = Input.GetAxisRaw("Vertical");
        Vector3 direction = new Vector3(hor, 0, ver).normalized;
        
        isGrounded = playerController.isGrounded;

            if (direction.magnitude >= 0.1f)
            {
                float targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cam.eulerAngles.y;
                float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);
                transform.rotation = Quaternion.Euler(0f, angle, 0f);

                Vector3 moveDir = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;
                playerController.Move(moveDir.normalized * speed * Time.deltaTime);
            }

        moveVector = new Vector3(0, verticalVelosity, 0);
        playerController.Move(moveVector);
        if (isGrounded)
        {
            verticalVelosity -= 0;
        }
        else
        {
            verticalVelosity -= 1;
        }

       

       
    }
}

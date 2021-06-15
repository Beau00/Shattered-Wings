using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThirdPersonMov : MonoBehaviour
{
    public Rigidbody playerController;
    public Transform cam;
    float turnSmoothVelocity;
    public float turnSmoothTime = 0.1f;
    bool isGrounded;
    Vector3 moveVector;
    float verticalVelosity;
    private Animator buncaAnimator;
    public AnimationCurve curve;

    void Start()
    {
        buncaAnimator = GetComponent<Animator>();
    }

    void Update() // normal movement
    {
        
        if (isGrounded)
        {
            verticalVelosity = 0;
        }
        else
        {
            verticalVelosity = -1;
        }
        if (moveVector.x.Equals(Vector3.zero.x) && moveVector.z.Equals(Vector3.zero.z))
        {   
            //idle
            buncaAnimator.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
            Move(0f);
        }
        else if((Input.GetButton("Left Shift") || Input.GetButtonDown("Left Shift")) && PickUp.heldItem == null)
        {
            //run       
            Move(9f);
            buncaAnimator.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
        }
        else
        {  
            //walk
            Move(1.8f);
            buncaAnimator.SetFloat("Speed", 0.5f, 0.1f, Time.deltaTime);
        }
       
        transform.position += new Vector3(0, -1f * Time.deltaTime, 0);
    }

    private void Move(float speed)
    {
        
        float hor = Input.GetAxisRaw("Horizontal");
        float ver = Input.GetAxisRaw("Vertical");
        Vector3 direction = new Vector3(hor, 0, ver).normalized;
       

        if (direction.magnitude >= 0.1f)
        {
            float targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cam.eulerAngles.y;
            float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);
            transform.rotation = Quaternion.Euler(0f, angle, 0f);
            Vector3 moveDir = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;

           
            transform.position += moveDir.normalized * speed * Time.deltaTime;
        }
        moveVector = new Vector3(direction.x, verticalVelosity, direction.z);
        if(PickUp.heldItem != null)
        {
            Vector3 pos = PickUp.heldItem.transform.position;
            pos = new Vector3(pos.x, pos.y + verticalVelosity, pos.z);
            PickUp.heldItem.transform.position = pos;
            transform.position += moveVector;
        }
    }
}

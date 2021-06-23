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
    float targetAngle;

    bool done = true;
    bool changed = false;

    void Start()
    {
        buncaAnimator = GetComponent<Animator>();

    }

    private void Update()
    {
        
       
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
            Gravity();
        }
        else
        {  
            //walk
            Move(1.8f);
            buncaAnimator.SetFloat("Speed", 0.5f, 0.1f, Time.deltaTime);
            Gravity();
        }


    }

    private void FixedUpdate()
    {
        if (moveVector.x.Equals(Vector3.zero.x) && moveVector.z.Equals(Vector3.zero.z))
        {
            //idle
            SetRotation();
        }
        else if ((Input.GetButton("Left Shift") || Input.GetButtonDown("Left Shift")) && PickUp.heldItem == null)
        {
            //run       
            SetRotation();
        }
        else
        {
            //walk
            SetRotation();
        }
    }

    private void SetRotation()
    {
        float hor = Input.GetAxisRaw("Horizontal");
        float ver = Input.GetAxisRaw("Vertical");
        Vector3 direction = new Vector3(hor, 0, ver).normalized;


        if (direction.magnitude >= 0.1f)
        {
            if (targetAngle != (Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cam.eulerAngles.y))
            {
                changed = true;
                StopAllCoroutines();
            }
            targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cam.eulerAngles.y;

            if (done || changed)
            {
                changed = false;
                done = false;
                StartCoroutine(LerpRotation(Quaternion.Euler(0f, targetAngle, 0f), 0.25f));
            }
           
        }
        moveVector = new Vector3(direction.x, verticalVelosity, direction.z);
    }

    private void Move(float speed)
    {
        
        float hor = Input.GetAxisRaw("Horizontal");
        float ver = Input.GetAxisRaw("Vertical");
        Vector3 direction = new Vector3(hor, 0, ver).normalized;
       

        if (direction.magnitude >= 0.1f)
        {
            
            targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cam.eulerAngles.y;
            //float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);

            
            Vector3 moveDir = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;

           
            transform.position += moveDir.normalized * speed * Time.deltaTime;
        }
        moveVector = new Vector3(direction.x, verticalVelosity, direction.z);
        //if(PickUp.heldItem != null)
        //{
        //    Vector3 pos = PickUp.heldItem.transform.position;
        //    pos = new Vector3(pos.x, pos.y + verticalVelosity, pos.z);
        //    PickUp.heldItem.transform.position = pos;
        //    transform.position += moveVector;
        //}
    }

    private void Gravity()
    {
        transform.position += new Vector3(0, -1f * Time.deltaTime, 0);
    }

    IEnumerator LerpRotation(Quaternion endRotation, float duration)
    {
        
        float time = 0;
        Quaternion startRotation = transform.rotation;
        while(time < duration)
        {
           
            transform.rotation = Quaternion.Lerp(startRotation, endRotation, time/duration);
            time += Time.deltaTime;
            yield return null;
        }
        transform.rotation = endRotation;
        done = true;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    public bool canjump = true;
    public float h;
    public float v;
    public Vector3 move;
    public float moveSpeed;
    public Vector3 jump;
    public Vector3 mouserotation;
    public int maxJump;
    public int timesJumped;
    public bool running = false;




    void Update()
    {
        if (running)
        {
            h = Input.GetAxis("Horizontal");
            v = Input.GetAxis("Vertical");
            move.x = h;
            move.z = v;
            GetComponent<Transform>().Translate(move * Time.deltaTime * moveSpeed * 3f);

        }
        else
        {
            h = Input.GetAxis("Horizontal");
            v = Input.GetAxis("Vertical");
            move.x = h;
            move.z = v;
            GetComponent<Transform>().Translate(move * Time.deltaTime * moveSpeed);

        }
        if (Input.GetButtonDown("Jump"))
        {
            if (timesJumped < maxJump)
            {
                timesJumped++;
                GetComponent<Rigidbody>().velocity = jump;
            }

        }
        if (Input.GetButtonDown("Left Shift"))
        {
            running = true;
        }
        if (Input.GetButtonUp("Left Shift"))
        {
            running = false;
        }

    }

    private void OnCollisionEnter(Collision collision)
    {
        timesJumped = 0;
    }
}

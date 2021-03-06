using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundPuzzle : MonoBehaviour
{
    public AudioSource lower, low, high, higher;
    public AudioSource click;
    public AudioSource open;
    public AudioSource close;
    public Transform doorOneCollider, doorTwoCollider, doorThreeCollider, doorFourCollider;

    public Animator door1, door2, door3, door4;
   
    public GameObject bookThing;
    public Transform bookThingpos;
    //public GameObject smollDoorOne, smollDoorTwo, smollDoorThree, smollDoorFour;
    public bool smolldoorOpenOne = false, smolldoorOpenTwo = false, smolldoorOpenThree = false, smolldoorOpenFour = false;

    public float doorRotation;
    public GameObject book;

    public GameObject player;
    public float delay;

    public bool playFinishSound = true;

    // animation add && main item systemm

    // Start is called before the first frame update
    void Start()
    {
        door1.SetBool("C1", true);
        door2.SetBool("C2", true);
        door3.SetBool("C3", true);
        door4.SetBool("C4", true);

        book.SetActive(false);
        close.Stop();
        open.Stop();
        lower.Stop();
        low.Stop();
        high.Stop();
        higher.Stop();
        click.Stop();
    }

    void Update()
    {
        Collider[] collidersOne = Physics.OverlapSphere(doorOneCollider.transform.position, 1);
        foreach (Collider collider1 in collidersOne)
        {
            bool nameCheck = collider1.transform.name == player.transform.name;
            if (nameCheck && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                lower.PlayDelayed(1.2f);
                smolldoorOpenOne = true;
                delay = Time.time;
                door1.SetBool("Open", true);
                door1.SetBool("CloseOpen", true);
                door1.SetBool("OpenClose", false);
                open.Play();
            }
            else if (nameCheck && smolldoorOpenOne == true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {

                smolldoorOpenOne = false;
                delay = Time.time;

                StartCoroutine(DelayedSoundStopOne());

                door1.SetBool("OpenClose", true);
                door1.SetBool("CloseOpen", false);
                door1.SetBool("Open", false);
                close.Play();

            }
        }

        Collider[] collidersTwo = Physics.OverlapSphere(doorTwoCollider.transform.position, 1);
        foreach (Collider collider2 in collidersTwo)
        {
            bool nameCheck = collider2.transform.name == player.transform.name;
            if (nameCheck && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                low.PlayDelayed(1.2f);
                smolldoorOpenTwo = true;
                delay = Time.time;
                door2.SetBool("DoorOpen", true);
                door2.SetBool("DoorCloseOpen", true);
                door2.SetBool("DoorClose", false);
                open.Play();
            }
            else if (nameCheck && smolldoorOpenTwo == true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {

                smolldoorOpenTwo = false;
                delay = Time.time;

                StartCoroutine(DelayedSoundStopTwo());
                
                door2.SetBool("DoorClose", true);
                door2.SetBool("DoorOpen", false);
                door2.SetBool("DoorCloseOpen", false);
                close.Play();
            }
        }

        Collider[] collidersThree = Physics.OverlapSphere(doorThreeCollider.transform.position, 1);
        foreach (Collider collider3 in collidersThree)
        {
            bool nameCheck = collider3.transform.name == player.transform.name;
            if (nameCheck && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                high.PlayDelayed(1.2f);
                smolldoorOpenThree = true;
                delay = Time.time;
                door3.SetBool("OpenD", true);
                door3.SetBool("CloseD", false);
                door3.SetBool("CloseDOpenD", true);
                open.Play();
            }
            else if (nameCheck && smolldoorOpenThree == true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {

                smolldoorOpenThree = false;
                delay = Time.time;

                StartCoroutine(DelayedSoundStopThree());

                door3.SetBool("CloseD", true);
                door3.SetBool("OpenD", false);
                door3.SetBool("CloseDOpenD", false);
                close.Play();
            }
        }

        Collider[] collidersFour = Physics.OverlapSphere(doorFourCollider.transform.position, 1);
        foreach (Collider collider4 in collidersFour)
        {
            bool nameCheck = collider4.transform.name == player.transform.name;
            if (nameCheck && Input.GetButtonDown("E") && Time.time - delay > 0.5f)
            {
                higher.PlayDelayed(1.2f);
                smolldoorOpenFour = true;
                delay = Time.time;
                door4.SetBool("OpenTrue", true);
                door4.SetBool("OpenToClose", false);
                door4.SetBool("CloseToOpen", true);
                open.Play();
            }
            else if (nameCheck && smolldoorOpenFour == true && Input.GetButtonDown("F") && Time.time - delay > 0.5f)
            {

                smolldoorOpenFour = false;
                delay = Time.time;

                StartCoroutine(DelayedSoundStopFour());

                door4.SetBool("OpenToClose", true);
                door4.SetBool("OpenTrue", false);
                door4.SetBool("CloseToOpen", false);
                close.Play();


            }
        }


        IEnumerator DelayedSoundStopFour()
        {
            yield return new WaitForSeconds(1.2f);
            higher.Stop();
            
        }
        IEnumerator DelayedSoundStopThree()
        {
            yield return new WaitForSeconds(1.2f);
            high.Stop();
        }
        IEnumerator DelayedSoundStopTwo()
        {
            yield return new WaitForSeconds(1.2f);
            low.Stop();
        }
        IEnumerator DelayedSoundStopOne()
        {
            yield return new WaitForSeconds(1.2f);
            lower.Stop();
        }

        IEnumerator DelayedBookPosition()
        {

            yield return new WaitForSeconds(1f);
            
            bookThing.transform.position = bookThingpos.position;
            book.SetActive(true);
        }

        IEnumerator EndingClose()
        {
            yield return new WaitForSeconds(4);
           

            door4.SetBool("OpenToClose", true);
            door4.SetBool("OpenTrue", false);
            door4.SetBool("CloseToOpen", false);

            door1.SetBool("OpenClose", true);
            door1.SetBool("CloseOpen", false);
            door1.SetBool("Open", false);

            smolldoorOpenFour = false;
            smolldoorOpenOne = false;

            yield return new WaitForSeconds(0.4f);

            close.Stop();
            open.Stop();
            lower.Stop();
            low.Stop();
            high.Stop();
            higher.Stop();
            click.Stop();
        }

        if (smolldoorOpenFour && smolldoorOpenOne && playFinishSound)
        {
            click.PlayDelayed(3f);
            Debug.Log("LEZZ GOOOOOOO");
            StartCoroutine(DelayedBookPosition());
            StopCoroutine(DelayedBookPosition());
            playFinishSound = false;
            StartCoroutine(EndingClose());

        }
        else if ((!smolldoorOpenFour || !smolldoorOpenOne) && !playFinishSound)
        {
            playFinishSound = true;
            Debug.Log("DONT GOOO");
        }

    }
}

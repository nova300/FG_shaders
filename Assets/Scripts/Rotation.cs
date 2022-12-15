using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour
{
    [SerializeField] float speed = 1.0f;
    void Update(){
        transform.Rotate(-speed * Time.deltaTime * 1.3f, speed * Time.deltaTime , 0);
    }
 
}

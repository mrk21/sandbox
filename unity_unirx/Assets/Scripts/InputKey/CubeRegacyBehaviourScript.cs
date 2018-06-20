using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace InputKey
{
    public class CubeRegacyBehaviourScript : MonoBehaviour
    {
        private Boolean isEnteredSpaceKey;
        private Rigidbody rigidBody;

        private void Start()
        {
            isEnteredSpaceKey = false;
            rigidBody = GetComponent<Rigidbody>();
        }

        private void Update()
        {
            isEnteredSpaceKey = Input.GetKey(KeyCode.Space);
        }

        private void FixedUpdate()
        {
            if (isEnteredSpaceKey) {
                rigidBody.AddForce(Vector3.up, ForceMode.VelocityChange);
            }
        }
    }
}
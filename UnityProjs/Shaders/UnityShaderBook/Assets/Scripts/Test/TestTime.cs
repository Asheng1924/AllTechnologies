using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestTime : MonoBehaviour
{

    public Material material;
    // Start is called before the first frame update
    void Start()
    {

      //Debug.Log(  Shader.GetGlobalFloat("_Uv_x"));
    }

    // Update is called once per frame
    void Update()
    {
        // Debug.Log(Time.realtimeSinceStartup);

        Debug.Log(Shader.GetGlobalFloat("_Uv_x"));
    }
}

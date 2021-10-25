using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class TestTmp: MonoBehaviour
{

    [MenuItem("Tools/Test")]
    public static void Test()
    {

        float f = 1.0f / 8f;
        Debug.Log(f);



        //float  f =  Mathf.SmoothStep(0.5f, 1.0f, 0.5f);
        //float v = Mathf.Lerp(0.1f, 1, 0);
        //Debug.Log(v);
    }


}

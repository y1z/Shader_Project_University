using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderEditor : MonoBehaviour
{

    public float _Distortion = 1.0f;
    private int _DisplacementID = Shader.PropertyToID("_displacement_control");
    public Vector2 _Displacement = Vector2.zero;
    private float _Counter = 0;
    public Material _Mat;


    void Start()
    {
       _Mat = GetComponent<Renderer>().material;
        
    }

    // Update is called once per frame
    void Update()
    {
        _Counter += Time.deltaTime;
        _Counter %= 10f;
        _Displacement.x = _Counter;
        _Mat.SetVector(_DisplacementID, _Displacement);

    }
}

Shader "Unlit/Sh_Test_Lerp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color 1", color) = (0.0,0.0,1.0,1.0)
        _Color2 ("Color 2", color) = (0.0,1.0,0.0,1.0)
        _Color3 ("Color 3", color) = (1.0,0.0,0.0,1.0)
        _Slider("my Slider", range(0,1)) = 0.5
        _Slider2("my Slider 2", range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
 
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _Color2;
            float4 _Color3;
            float _Slider;
            float _Slider2;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.normal = v.normal;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);
                fixed4 col = 1;
                float dotProduct = dot(float3(0,1,0), i.normal);
                dotProduct += 1;
                dotProduct *= 0.5;

                float step1 = step(dotProduct, _Slider);



                float step2 = step(dotProduct, _Slider2);

                col = lerp(_Color, lerp(_Color2, _Color3, step1), step2);


                float4 smoothStep = smoothstep(_Slider, _Slider2, tex.r);

                return smoothStep;
            }
            ENDCG
        }
    }
}

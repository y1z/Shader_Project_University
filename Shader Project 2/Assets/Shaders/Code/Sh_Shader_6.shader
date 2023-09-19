Shader "Unlit/Sh_Shader_6"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color1 ("Color1", color) = (1,1,1,1)
        _LightDir ("Light Direction", vector) = (0.5,0.5,0,0)
    }
    SubShader
    {
        Tags 
        { "RenderType"="Transparent" 
    
           "Queue"="Transparent"
        }
        LOD 100
        ZWrite Off
        //Cull Off
        //Blend One One // < -- aditivo
        Blend SrcAlpha OneMinusSrcAlpha // <- alph

        //Blend One OneMinusSrcAlpha

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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color1;
            half4 _LightDir;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half value = saturate(dot(_LightDir.xyz,i.normal));
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                _Color1.rgb *= value;
                col.rgb *= col.a;
                return col * _Color1;
            }
            ENDCG
        }
    }
}

Shader "Unlit/Sh_Shader_4"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata input)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(input.vertex);
                o.uv = TRANSFORM_TEX(input.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f input) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, input.uv);
                return col;
            }
            ENDCG
        }
    }
}

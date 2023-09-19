Shader "Unlit/Sh_Test"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "blue" {}
        _Range ("Range", range(0,1)) = 0.5
        _Color("My Color", color) = (0.7, 0, 0, 1)
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
            float4 _Color;
            float _Range;

            // un comment the line below if you want to use mipmaps 
            //float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // un comment the line below if you want to use mipmaps
               // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv_copy = i.uv;
                uv_copy.x += _Range;

                // sample the texture
                fixed4 col = tex2D(_MainTex, uv_copy);
                float4 debug = float4(i.uv.x, i.uv.y, 0, 1);

                return  col * _Color;
            }
            ENDCG
        }
    }
}

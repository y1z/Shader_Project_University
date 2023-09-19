Shader "Unlit/Shader_3"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _ShowTex("Snow Texture(top Texture)", 2D) = "bule" {}
        _ShowStart("Show Start", range(0,1)) =0.5
        _ShowEnd("Show end", range(0,1)) = 0.5
        _ShowDir("Show Direction", vector) = (0,1,0,0)
        _LightColor("Light Color", color) = (1,1,1,1)
        _LightDir("LIght Direction", vector) = (0,1,0,0)
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
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
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            sampler2D _ShowTex;
            float4 _MainTex_ST;
            half _ShowStart;
            half _ShowEnd;
            half4 _ShowDir;
            half4 _LightColor;
            half4 _LightDir;

            inline half HalfDot(in half3 _a, in half3 _b) {
                return (dot(normalize(_a), normalize(_b)) + 1 ) * 0.5;
            }

            inline half3 GetWorldPos(in half4 _v) {
                return mul(unity_ObjectToWorld, _v).xyz;
            }


            v2f vert(appdata input)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos( input.vertex);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.normal = input.normal;
                output.worldNormal = UnityObjectToWorldNormal(input.normal);
               // output.worldNormal = normalize(
              //      mul(input.normal, (float3x3)unity_WorldToObject));

                output.worldPos = GetWorldPos(input.vertex);
                return output;
            }

            fixed4 frag(v2f input) : SV_Target
            {

                half4 result = 1;
                // sample the texture
                half4 tex1 = tex2D(_MainTex, input.uv);
                half4 tex2 = tex2D(_ShowTex, input.worldPos.xz);
                
                half dotProduct = HalfDot(input.worldNormal, _ShowDir.xyz);

                half showInterpolation = smoothstep(_ShowStart, _ShowEnd, dotProduct);
                
                half lightValueShadow = HalfDot(input.worldNormal, _LightDir);
                half lightValueColor = saturate(dot(input.worldNormal, _LightDir));

                half4 shadow = result * lightValueShadow;
                half4 lights = result * _LightColor;

                result = lerp(shadow, lights, lightValueColor);
               
                return result * lightValueColor * _LightColor * lerp(tex1, tex2, showInterpolation ) ;
            }
            ENDCG
        }
    }
}

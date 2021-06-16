Shader "Unlit/UnlitOutline"
{

    Properties{
              _Color("Main Color", Color) = (1,1,1,0.5)
              _Outline("Outline Color", Color) = (0,0,0,1)
              _MainTex("Albedo (RGB)", 2D) = "white" {}
              _Glossiness("Smoothness", Range(0,1)) = 0.5
              _Size("Outline Thickness", Float) = 1.5
    }

        SubShader{

                Tags {"RenderType" = "Opaque"}
                LOD 400



                Pass
                {

                    Stencil
                    {
                        Ref  1
                        Comp NotEqual
                    }

                     HLSLPROGRAM
                    #include "UnityCG.cginc"
                    #pragma vertex vert                     
                    #pragma fragment frag                   


                    half _Size;
                    half _Outline;
                    half _Color;

                    struct v2f
                    {
                        float4 pos : SV_POSITION;
                    };

                    v2f vert(appdata_base v)
                    {
                        v2f output;
                        v.vertex.xyz += v.normal * _Size;
                        output.pos = UnityObjectToClipPos(v.vertex);
                        return output;
                    }

                    float2 frag(v2f i) : SV_Target
                    {
                        return _Outline;
                    }

                        ENDHLSL
                }

                Tags { "RenderType" = "Opaque" }
                LOD 200

                Stencil
                {
                    Ref 1
                    Comp always
                    Pass replace
                }

                HLSLPROGRAM
                #pragma surface surf Standard fullforwardshadows
                #pragma target 3.0

                sampler2D _MainTex;



                half _Glossiness;

                void surf(Input IN, inout SurfaceOutputStandard output)
                {
                    float c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                    output.Albedo = c.rgb;
                    output.Smoothness = _Glossiness;
                    output.Alpha = c.a;
                }

                ENDHLSL
              }

                  FallBack "Diffuse"
}

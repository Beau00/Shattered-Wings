Shader "clouds shader"
{
    Properties
    {
        Color_7437754193f145e59097741d88ed7046("Color1", Color) = (0, 0, 0, 0)
        Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40("Color2", Color) = (0, 0, 0, 0)
        Vector1_2711331ea20245a38c5f9bdf46c3fc9e("Density", Float) = 1
        Vector1_44627893a65f4befa4d84a6adab02340("Falloff", Float) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
                // LightMode: <None>
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
        #define REQUIRE_DEPTH_TEXTURE
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpaceBiTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Color_7437754193f145e59097741d88ed7046;
        float4 Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
        float Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
        float Vector1_44627893a65f4befa4d84a6adab02340;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        { 
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2;
            Unity_Subtract_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, 0.5, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2);
            float3 _Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0 = float3(0, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2, 0);
            float3 _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2;
            Unity_Multiply_float(_Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                     length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                     length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2);
            float3 _Add_db278d594bf04f86ae5e130e26a513ea_Out_2;
            Unity_Add_float3(IN.WorldSpacePosition, _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2, _Add_db278d594bf04f86ae5e130e26a513ea_Out_2);
            float3 _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1 = TransformObjectToWorld(_Add_db278d594bf04f86ae5e130e26a513ea_Out_2.xyz);
            description.Position = _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_3ab5b7d2a28a4e508d576c8e4cf9a9bc_Out_0 = Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
            float4 _Property_391752a4152842bb97d39b39eca9d03f_Out_0 = Color_7437754193f145e59097741d88ed7046;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Saturate_f10aab65b00e45f3adc2c29d2beb1b9d_Out_1;
            Unity_Saturate_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Saturate_f10aab65b00e45f3adc2c29d2beb1b9d_Out_1);
            float4 _Lerp_195f278028864c37bb9fce5769393980_Out_3;
            Unity_Lerp_float4(_Property_3ab5b7d2a28a4e508d576c8e4cf9a9bc_Out_0, _Property_391752a4152842bb97d39b39eca9d03f_Out_0, (_Saturate_f10aab65b00e45f3adc2c29d2beb1b9d_Out_1.xxxx), _Lerp_195f278028864c37bb9fce5769393980_Out_3);
            float _Float_182454c50794463c9a2b5de6a0ddf923_Out_0 = 0;
            float _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2;
            Unity_Multiply_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, 2, _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2);
            float _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0 = Vector1_44627893a65f4befa4d84a6adab02340;
            float _Add_4514cffffab24965a8690c270b9429fd_Out_2;
            Unity_Add_float(_Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2, _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2);
            float _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3;
            Unity_Smoothstep_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Split_6a3026dd6d88406e9fa3b06506538d75_A_4, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0 = Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
            float _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2;
            Unity_Multiply_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0, _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            Unity_Multiply_float(_Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2);
            surface.BaseColor = (_Lerp_195f278028864c37bb9fce5769393980_Out_3.xyz);
            surface.Alpha = _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpaceBiTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Color_7437754193f145e59097741d88ed7046;
        float4 Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
        float Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
        float Vector1_44627893a65f4befa4d84a6adab02340;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        { 
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2;
            Unity_Subtract_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, 0.5, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2);
            float3 _Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0 = float3(0, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2, 0);
            float3 _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2;
            Unity_Multiply_float(_Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                     length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                     length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2);
            float3 _Add_db278d594bf04f86ae5e130e26a513ea_Out_2;
            Unity_Add_float3(IN.WorldSpacePosition, _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2, _Add_db278d594bf04f86ae5e130e26a513ea_Out_2);
            float3 _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1 = TransformObjectToWorld(_Add_db278d594bf04f86ae5e130e26a513ea_Out_2.xyz);
            description.Position = _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Float_182454c50794463c9a2b5de6a0ddf923_Out_0 = 0;
            float _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2;
            Unity_Multiply_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, 2, _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2);
            float _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0 = Vector1_44627893a65f4befa4d84a6adab02340;
            float _Add_4514cffffab24965a8690c270b9429fd_Out_2;
            Unity_Add_float(_Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2, _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2);
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3;
            Unity_Smoothstep_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Split_6a3026dd6d88406e9fa3b06506538d75_A_4, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0 = Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
            float _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2;
            Unity_Multiply_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0, _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            Unity_Multiply_float(_Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2);
            surface.Alpha = _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define REQUIRE_DEPTH_TEXTURE
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpaceBiTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Color_7437754193f145e59097741d88ed7046;
        float4 Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
        float Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
        float Vector1_44627893a65f4befa4d84a6adab02340;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        { 
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2;
            Unity_Subtract_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, 0.5, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2);
            float3 _Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0 = float3(0, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2, 0);
            float3 _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2;
            Unity_Multiply_float(_Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                     length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                     length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2);
            float3 _Add_db278d594bf04f86ae5e130e26a513ea_Out_2;
            Unity_Add_float3(IN.WorldSpacePosition, _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2, _Add_db278d594bf04f86ae5e130e26a513ea_Out_2);
            float3 _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1 = TransformObjectToWorld(_Add_db278d594bf04f86ae5e130e26a513ea_Out_2.xyz);
            description.Position = _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Float_182454c50794463c9a2b5de6a0ddf923_Out_0 = 0;
            float _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2;
            Unity_Multiply_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, 2, _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2);
            float _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0 = Vector1_44627893a65f4befa4d84a6adab02340;
            float _Add_4514cffffab24965a8690c270b9429fd_Out_2;
            Unity_Add_float(_Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2, _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2);
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3;
            Unity_Smoothstep_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Split_6a3026dd6d88406e9fa3b06506538d75_A_4, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0 = Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
            float _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2;
            Unity_Multiply_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0, _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            Unity_Multiply_float(_Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2);
            surface.Alpha = _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
                // LightMode: <None>
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
        #define REQUIRE_DEPTH_TEXTURE
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpaceBiTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Color_7437754193f145e59097741d88ed7046;
        float4 Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
        float Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
        float Vector1_44627893a65f4befa4d84a6adab02340;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        { 
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2;
            Unity_Subtract_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, 0.5, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2);
            float3 _Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0 = float3(0, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2, 0);
            float3 _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2;
            Unity_Multiply_float(_Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                     length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                     length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2);
            float3 _Add_db278d594bf04f86ae5e130e26a513ea_Out_2;
            Unity_Add_float3(IN.WorldSpacePosition, _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2, _Add_db278d594bf04f86ae5e130e26a513ea_Out_2);
            float3 _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1 = TransformObjectToWorld(_Add_db278d594bf04f86ae5e130e26a513ea_Out_2.xyz);
            description.Position = _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_3ab5b7d2a28a4e508d576c8e4cf9a9bc_Out_0 = Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
            float4 _Property_391752a4152842bb97d39b39eca9d03f_Out_0 = Color_7437754193f145e59097741d88ed7046;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Saturate_f10aab65b00e45f3adc2c29d2beb1b9d_Out_1;
            Unity_Saturate_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Saturate_f10aab65b00e45f3adc2c29d2beb1b9d_Out_1);
            float4 _Lerp_195f278028864c37bb9fce5769393980_Out_3;
            Unity_Lerp_float4(_Property_3ab5b7d2a28a4e508d576c8e4cf9a9bc_Out_0, _Property_391752a4152842bb97d39b39eca9d03f_Out_0, (_Saturate_f10aab65b00e45f3adc2c29d2beb1b9d_Out_1.xxxx), _Lerp_195f278028864c37bb9fce5769393980_Out_3);
            float _Float_182454c50794463c9a2b5de6a0ddf923_Out_0 = 0;
            float _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2;
            Unity_Multiply_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, 2, _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2);
            float _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0 = Vector1_44627893a65f4befa4d84a6adab02340;
            float _Add_4514cffffab24965a8690c270b9429fd_Out_2;
            Unity_Add_float(_Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2, _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2);
            float _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3;
            Unity_Smoothstep_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Split_6a3026dd6d88406e9fa3b06506538d75_A_4, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0 = Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
            float _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2;
            Unity_Multiply_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0, _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            Unity_Multiply_float(_Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2);
            surface.BaseColor = (_Lerp_195f278028864c37bb9fce5769393980_Out_3.xyz);
            surface.Alpha = _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpaceBiTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Color_7437754193f145e59097741d88ed7046;
        float4 Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
        float Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
        float Vector1_44627893a65f4befa4d84a6adab02340;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        { 
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2;
            Unity_Subtract_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, 0.5, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2);
            float3 _Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0 = float3(0, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2, 0);
            float3 _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2;
            Unity_Multiply_float(_Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                     length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                     length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2);
            float3 _Add_db278d594bf04f86ae5e130e26a513ea_Out_2;
            Unity_Add_float3(IN.WorldSpacePosition, _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2, _Add_db278d594bf04f86ae5e130e26a513ea_Out_2);
            float3 _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1 = TransformObjectToWorld(_Add_db278d594bf04f86ae5e130e26a513ea_Out_2.xyz);
            description.Position = _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Float_182454c50794463c9a2b5de6a0ddf923_Out_0 = 0;
            float _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2;
            Unity_Multiply_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, 2, _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2);
            float _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0 = Vector1_44627893a65f4befa4d84a6adab02340;
            float _Add_4514cffffab24965a8690c270b9429fd_Out_2;
            Unity_Add_float(_Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2, _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2);
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3;
            Unity_Smoothstep_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Split_6a3026dd6d88406e9fa3b06506538d75_A_4, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0 = Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
            float _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2;
            Unity_Multiply_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0, _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            Unity_Multiply_float(_Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2);
            surface.Alpha = _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define REQUIRE_DEPTH_TEXTURE
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpaceBiTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Color_7437754193f145e59097741d88ed7046;
        float4 Color_1c5d33e8b1344ba7a7b6d3e3fc1c0e40;
        float Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
        float Vector1_44627893a65f4befa4d84a6adab02340;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        { 
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2;
            Unity_Subtract_float(_Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, 0.5, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2);
            float3 _Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0 = float3(0, _Subtract_8f40b74b1c4a42ef81c7c2387fcd2d50_Out_2, 0);
            float3 _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2;
            Unity_Multiply_float(_Vector3_1807e246fa2c48aca3d3e625bbff2e8b_Out_0, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                     length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                     length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2);
            float3 _Add_db278d594bf04f86ae5e130e26a513ea_Out_2;
            Unity_Add_float3(IN.WorldSpacePosition, _Multiply_5b1b6da75e19440a9561d7a305cf9b1d_Out_2, _Add_db278d594bf04f86ae5e130e26a513ea_Out_2);
            float3 _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1 = TransformObjectToWorld(_Add_db278d594bf04f86ae5e130e26a513ea_Out_2.xyz);
            description.Position = _Transform_e8d7596929bf436b9c2fc5d49ce3d1d8_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Float_182454c50794463c9a2b5de6a0ddf923_Out_0 = 0;
            float _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2;
            Unity_Multiply_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, 2, _Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2);
            float _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0 = Vector1_44627893a65f4befa4d84a6adab02340;
            float _Add_4514cffffab24965a8690c270b9429fd_Out_2;
            Unity_Add_float(_Multiply_dcb66ba350ca4728a15b5ba731d9ae75_Out_2, _Property_6ca7e2cdcd0041f7ab5611bcf2c461f4_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2);
            float _Split_7c2c4520ffde47078b1da8f223f4786d_R_1 = IN.WorldSpacePosition[0];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_G_2 = IN.WorldSpacePosition[1];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_B_3 = IN.WorldSpacePosition[2];
            float _Split_7c2c4520ffde47078b1da8f223f4786d_A_4 = 0;
            float2 _Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0 = float2(_Split_7c2c4520ffde47078b1da8f223f4786d_R_1, _Split_7c2c4520ffde47078b1da8f223f4786d_B_3);
            float _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.5, _Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2);
            float2 _Add_b18ba2290fd94fd9852db63187b41bac_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_6f2fe8e86faa4f19935b5db625629e64_Out_2.xx), _Add_b18ba2290fd94fd9852db63187b41bac_Out_2);
            float _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2;
            Unity_GradientNoise_float(_Add_b18ba2290fd94fd9852db63187b41bac_Out_2, 0.1, _GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2);
            float _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1, _Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2);
            float2 _Add_4b379be856fe43e998ae124a61349a7a_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_4dafb2d342f94d7f86559f5d5a13987d_Out_2.xx), _Add_4b379be856fe43e998ae124a61349a7a_Out_2);
            float _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2;
            Unity_SimpleNoise_float(_Add_4b379be856fe43e998ae124a61349a7a_Out_2, 1, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2);
            float _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2;
            Unity_Add_float(_GradientNoise_59f785d93b4a408cbee8379e652067d3_Out_2, _SimpleNoise_4975977d97bd40fb91709d328d80f0f9_Out_2, _Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2);
            float _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 1.5, _Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2);
            float2 _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2;
            Unity_Add_float2(_Vector2_f29837e29f6c40d3b70feb21bc677387_Out_0, (_Multiply_d519cbc115ee4efb8b69042f9af2acbf_Out_2.xx), _Add_8c9233841a1847ce82e6657fd2cb089e_Out_2);
            float _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2;
            Unity_SimpleNoise_float(_Add_8c9233841a1847ce82e6657fd2cb089e_Out_2, 0.5, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2);
            float _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2;
            Unity_Multiply_float(_Add_f47669bfbe924aa6a194ed584f1f52c7_Out_2, _SimpleNoise_df1675f85a894d73ac0a49e0e9e7d44d_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2);
            float _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3;
            Unity_Smoothstep_float(_Float_182454c50794463c9a2b5de6a0ddf923_Out_0, _Add_4514cffffab24965a8690c270b9429fd_Out_2, _Multiply_74057c35c2d64a378a343603f2e58e35_Out_2, _Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Split_6a3026dd6d88406e9fa3b06506538d75_A_4, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0 = Vector1_2711331ea20245a38c5f9bdf46c3fc9e;
            float _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2;
            Unity_Multiply_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_1c7d71726a894648a611dcbbffaa7b78_Out_0, _Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Multiply_12510d8bdea34f8fb2c0852a7511f30c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            Unity_Multiply_float(_Smoothstep_9e0eec83d07345d8abf9e94a15210815_Out_3, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2);
            surface.Alpha = _Multiply_7e433846dba545fdaf2a87340b1bb456_Out_2;
            surface.AlphaClipThreshold = 0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
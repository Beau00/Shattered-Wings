Shader "clouds shader"
{
    Properties
    {
        Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7("rotation", Vector) = (1, 0, 0, 0)
        Vector1_eec6f57c1eb847e9afe01a2b71fefa9c("Noise Scale", Float) = 1
        Vector1_6d024a442e4445a58392f940d9ca41eb("Noise Speed", Float) = 1
        Vector1_c00b63f6836648a7b404f63ff9065362("Noise Height", Float) = 1
        Vector4_d8f745072ed34551b6fbab27ac15da6c("Noise Remap", Vector) = (0, 1, -1, 1)
        Color_a8f6d59b451943b886190be35c4cdec4("Color Peak", Color) = (1, 1, 1, 0)
        Color_827b3f2af1264ab790fcd641c03a1323("Color Valley", Color) = (0, 0, 0, 0)
        Vector1_d93beab1dfdf47d0ac78237774641e04("Noise Edge 1", Float) = 0
        Vector1_e327f3b0e4ab48289380776fefe94635("Noise Edge 2", Float) = 1
        Vector1_ceec7645019a4eb3a3d10d983ab4817d("Noise Power", Float) = 2
        Vector1_3800208a35b94be88cbefc54fa78eac4("Base scale", Float) = 5
        Vector1_d596022c25ce4d75a4c963ee0d8f4265("Base speedie", Float) = 1
        Vector1_60b7d05b0dea41849d4f1e21bba834be("Base strength", Float) = 0
        Vector1_2c69c7860db641e596c8243fac652130("Emission strength", Float) = 2
        Vector1_57735d99dc8d4e9e809d415002dc722c("Curvature Radius", Float) = 0
        Vector1_ad077ce7c02a464b9a777f548adfc23a("Fresnel Power", Float) = 1
        Vector1_15e77529abc84190897ffcf9ad860c74("Fresnel Opacity", Float) = 1
        Vector1_0b48029a62c5496697a9c08b0ac7b682("Fade Depth", Float) = 1
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
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
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
            float3 normalWS;
            float3 viewDirectionWS;
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
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 WorldSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float3 interp2 : TEXCOORD2;
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
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyz =  input.viewDirectionWS;
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
            output.normalWS = input.interp1.xyz;
            output.viewDirectionWS = input.interp2.xyz;
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
        float4 Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
        float Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
        float Vector1_6d024a442e4445a58392f940d9ca41eb;
        float Vector1_c00b63f6836648a7b404f63ff9065362;
        float4 Vector4_d8f745072ed34551b6fbab27ac15da6c;
        float4 Color_a8f6d59b451943b886190be35c4cdec4;
        float4 Color_827b3f2af1264ab790fcd641c03a1323;
        float Vector1_d93beab1dfdf47d0ac78237774641e04;
        float Vector1_e327f3b0e4ab48289380776fefe94635;
        float Vector1_ceec7645019a4eb3a3d10d983ab4817d;
        float Vector1_3800208a35b94be88cbefc54fa78eac4;
        float Vector1_d596022c25ce4d75a4c963ee0d8f4265;
        float Vector1_60b7d05b0dea41849d4f1e21bba834be;
        float Vector1_2c69c7860db641e596c8243fac652130;
        float Vector1_57735d99dc8d4e9e809d415002dc722c;
        float Vector1_ad077ce7c02a464b9a777f548adfc23a;
        float Vector1_15e77529abc84190897ffcf9ad860c74;
        float Vector1_0b48029a62c5496697a9c08b0ac7b682;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
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
            float _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2);
            float _Property_1d66ab0475594f69bda44245570f56fe_Out_0 = Vector1_57735d99dc8d4e9e809d415002dc722c;
            float _Divide_78d0724741b34bbda66a129545fde3cd_Out_2;
            Unity_Divide_float(_Distance_ddadd30a38c74dec8cb970523718fc48_Out_2, _Property_1d66ab0475594f69bda44245570f56fe_Out_0, _Divide_78d0724741b34bbda66a129545fde3cd_Out_2);
            float _Power_e62d01748d5142b981831d792c521de6_Out_2;
            Unity_Power_float(_Divide_78d0724741b34bbda66a129545fde3cd_Out_2, 3, _Power_e62d01748d5142b981831d792c521de6_Out_2);
            float3 _Multiply_831b6234304c4624973fb10dda220ee8_Out_2;
            Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_e62d01748d5142b981831d792c521de6_Out_2.xxx), _Multiply_831b6234304c4624973fb10dda220ee8_Out_2);
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float3 _Multiply_8a307d0314984df193f50bea862ea73f_Out_2;
            Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxx), _Multiply_8a307d0314984df193f50bea862ea73f_Out_2);
            float _Property_34bfc41539894c70af1f8e4106e10fe5_Out_0 = Vector1_c00b63f6836648a7b404f63ff9065362;
            float3 _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2;
            Unity_Multiply_float(_Multiply_8a307d0314984df193f50bea862ea73f_Out_2, (_Property_34bfc41539894c70af1f8e4106e10fe5_Out_0.xxx), _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2);
            float3 _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2);
            float3 _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            Unity_Add_float3(_Multiply_831b6234304c4624973fb10dda220ee8_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2, _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2);
            description.Position = _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_538e67f768b54c9492e39a41716da0be_Out_0 = Color_827b3f2af1264ab790fcd641c03a1323;
            float4 _Property_dca80baf2f544b908f8891da346aa5b2_Out_0 = Color_a8f6d59b451943b886190be35c4cdec4;
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float4 _Lerp_7b07d5aa22e847e89b0c7a55658da018_Out_3;
            Unity_Lerp_float4(_Property_538e67f768b54c9492e39a41716da0be_Out_0, _Property_dca80baf2f544b908f8891da346aa5b2_Out_0, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxxx), _Lerp_7b07d5aa22e847e89b0c7a55658da018_Out_3);
            float _Property_fc48609bbf27471da3a916d7dacde0b6_Out_0 = Vector1_ad077ce7c02a464b9a777f548adfc23a;
            float _FresnelEffect_c9efc5c6209547f7aa450492c217a29f_Out_3;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_fc48609bbf27471da3a916d7dacde0b6_Out_0, _FresnelEffect_c9efc5c6209547f7aa450492c217a29f_Out_3);
            float _Multiply_2d9bd770f6e14e8485da257c287635ca_Out_2;
            Unity_Multiply_float(_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2, _FresnelEffect_c9efc5c6209547f7aa450492c217a29f_Out_3, _Multiply_2d9bd770f6e14e8485da257c287635ca_Out_2);
            float _Property_3578aa3bf4e14a27a6928cdb85627563_Out_0 = Vector1_15e77529abc84190897ffcf9ad860c74;
            float _Multiply_eb587a30d3a045f6b566daeaffab4583_Out_2;
            Unity_Multiply_float(_Multiply_2d9bd770f6e14e8485da257c287635ca_Out_2, _Property_3578aa3bf4e14a27a6928cdb85627563_Out_0, _Multiply_eb587a30d3a045f6b566daeaffab4583_Out_2);
            float4 _Add_45bbe4f9380e4de6ba3a33b8835b0b38_Out_2;
            Unity_Add_float4(_Lerp_7b07d5aa22e847e89b0c7a55658da018_Out_3, (_Multiply_eb587a30d3a045f6b566daeaffab4583_Out_2.xxxx), _Add_45bbe4f9380e4de6ba3a33b8835b0b38_Out_2);
            float _Property_cde31309593140ef8d8e0107529b5fbd_Out_0 = Vector1_2c69c7860db641e596c8243fac652130;
            float4 _Multiply_8b669176027c45d09ca5773c1c4521b9_Out_2;
            Unity_Multiply_float(_Add_45bbe4f9380e4de6ba3a33b8835b0b38_Out_2, (_Property_cde31309593140ef8d8e0107529b5fbd_Out_0.xxxx), _Multiply_8b669176027c45d09ca5773c1c4521b9_Out_2);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2;
            Unity_Subtract_float(_Split_6a3026dd6d88406e9fa3b06506538d75_A_4, 1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2);
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0 = Vector1_0b48029a62c5496697a9c08b0ac7b682;
            float _Divide_78f64528e160459c81392b7d2a45a34c_Out_2;
            Unity_Divide_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0, _Divide_78f64528e160459c81392b7d2a45a34c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Divide_78f64528e160459c81392b7d2a45a34c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            Unity_Smoothstep_float(0, 1, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3);
            surface.BaseColor = (_Multiply_8b669176027c45d09ca5773c1c4521b9_Out_2.xyz);
            surface.Alpha = _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        	float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);


            output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph


            output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
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
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 WorldSpaceNormal;
            float3 ObjectSpaceTangent;
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
        float4 Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
        float Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
        float Vector1_6d024a442e4445a58392f940d9ca41eb;
        float Vector1_c00b63f6836648a7b404f63ff9065362;
        float4 Vector4_d8f745072ed34551b6fbab27ac15da6c;
        float4 Color_a8f6d59b451943b886190be35c4cdec4;
        float4 Color_827b3f2af1264ab790fcd641c03a1323;
        float Vector1_d93beab1dfdf47d0ac78237774641e04;
        float Vector1_e327f3b0e4ab48289380776fefe94635;
        float Vector1_ceec7645019a4eb3a3d10d983ab4817d;
        float Vector1_3800208a35b94be88cbefc54fa78eac4;
        float Vector1_d596022c25ce4d75a4c963ee0d8f4265;
        float Vector1_60b7d05b0dea41849d4f1e21bba834be;
        float Vector1_2c69c7860db641e596c8243fac652130;
        float Vector1_57735d99dc8d4e9e809d415002dc722c;
        float Vector1_ad077ce7c02a464b9a777f548adfc23a;
        float Vector1_15e77529abc84190897ffcf9ad860c74;
        float Vector1_0b48029a62c5496697a9c08b0ac7b682;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
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
            float _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2);
            float _Property_1d66ab0475594f69bda44245570f56fe_Out_0 = Vector1_57735d99dc8d4e9e809d415002dc722c;
            float _Divide_78d0724741b34bbda66a129545fde3cd_Out_2;
            Unity_Divide_float(_Distance_ddadd30a38c74dec8cb970523718fc48_Out_2, _Property_1d66ab0475594f69bda44245570f56fe_Out_0, _Divide_78d0724741b34bbda66a129545fde3cd_Out_2);
            float _Power_e62d01748d5142b981831d792c521de6_Out_2;
            Unity_Power_float(_Divide_78d0724741b34bbda66a129545fde3cd_Out_2, 3, _Power_e62d01748d5142b981831d792c521de6_Out_2);
            float3 _Multiply_831b6234304c4624973fb10dda220ee8_Out_2;
            Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_e62d01748d5142b981831d792c521de6_Out_2.xxx), _Multiply_831b6234304c4624973fb10dda220ee8_Out_2);
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float3 _Multiply_8a307d0314984df193f50bea862ea73f_Out_2;
            Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxx), _Multiply_8a307d0314984df193f50bea862ea73f_Out_2);
            float _Property_34bfc41539894c70af1f8e4106e10fe5_Out_0 = Vector1_c00b63f6836648a7b404f63ff9065362;
            float3 _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2;
            Unity_Multiply_float(_Multiply_8a307d0314984df193f50bea862ea73f_Out_2, (_Property_34bfc41539894c70af1f8e4106e10fe5_Out_0.xxx), _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2);
            float3 _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2);
            float3 _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            Unity_Add_float3(_Multiply_831b6234304c4624973fb10dda220ee8_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2, _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2);
            description.Position = _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2;
            Unity_Subtract_float(_Split_6a3026dd6d88406e9fa3b06506538d75_A_4, 1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2);
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0 = Vector1_0b48029a62c5496697a9c08b0ac7b682;
            float _Divide_78f64528e160459c81392b7d2a45a34c_Out_2;
            Unity_Divide_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0, _Divide_78f64528e160459c81392b7d2a45a34c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Divide_78f64528e160459c81392b7d2a45a34c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            Unity_Smoothstep_float(0, 1, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3);
            surface.Alpha = _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
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
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 WorldSpaceNormal;
            float3 ObjectSpaceTangent;
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
        float4 Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
        float Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
        float Vector1_6d024a442e4445a58392f940d9ca41eb;
        float Vector1_c00b63f6836648a7b404f63ff9065362;
        float4 Vector4_d8f745072ed34551b6fbab27ac15da6c;
        float4 Color_a8f6d59b451943b886190be35c4cdec4;
        float4 Color_827b3f2af1264ab790fcd641c03a1323;
        float Vector1_d93beab1dfdf47d0ac78237774641e04;
        float Vector1_e327f3b0e4ab48289380776fefe94635;
        float Vector1_ceec7645019a4eb3a3d10d983ab4817d;
        float Vector1_3800208a35b94be88cbefc54fa78eac4;
        float Vector1_d596022c25ce4d75a4c963ee0d8f4265;
        float Vector1_60b7d05b0dea41849d4f1e21bba834be;
        float Vector1_2c69c7860db641e596c8243fac652130;
        float Vector1_57735d99dc8d4e9e809d415002dc722c;
        float Vector1_ad077ce7c02a464b9a777f548adfc23a;
        float Vector1_15e77529abc84190897ffcf9ad860c74;
        float Vector1_0b48029a62c5496697a9c08b0ac7b682;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
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
            float _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2);
            float _Property_1d66ab0475594f69bda44245570f56fe_Out_0 = Vector1_57735d99dc8d4e9e809d415002dc722c;
            float _Divide_78d0724741b34bbda66a129545fde3cd_Out_2;
            Unity_Divide_float(_Distance_ddadd30a38c74dec8cb970523718fc48_Out_2, _Property_1d66ab0475594f69bda44245570f56fe_Out_0, _Divide_78d0724741b34bbda66a129545fde3cd_Out_2);
            float _Power_e62d01748d5142b981831d792c521de6_Out_2;
            Unity_Power_float(_Divide_78d0724741b34bbda66a129545fde3cd_Out_2, 3, _Power_e62d01748d5142b981831d792c521de6_Out_2);
            float3 _Multiply_831b6234304c4624973fb10dda220ee8_Out_2;
            Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_e62d01748d5142b981831d792c521de6_Out_2.xxx), _Multiply_831b6234304c4624973fb10dda220ee8_Out_2);
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float3 _Multiply_8a307d0314984df193f50bea862ea73f_Out_2;
            Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxx), _Multiply_8a307d0314984df193f50bea862ea73f_Out_2);
            float _Property_34bfc41539894c70af1f8e4106e10fe5_Out_0 = Vector1_c00b63f6836648a7b404f63ff9065362;
            float3 _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2;
            Unity_Multiply_float(_Multiply_8a307d0314984df193f50bea862ea73f_Out_2, (_Property_34bfc41539894c70af1f8e4106e10fe5_Out_0.xxx), _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2);
            float3 _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2);
            float3 _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            Unity_Add_float3(_Multiply_831b6234304c4624973fb10dda220ee8_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2, _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2);
            description.Position = _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2;
            Unity_Subtract_float(_Split_6a3026dd6d88406e9fa3b06506538d75_A_4, 1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2);
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0 = Vector1_0b48029a62c5496697a9c08b0ac7b682;
            float _Divide_78f64528e160459c81392b7d2a45a34c_Out_2;
            Unity_Divide_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0, _Divide_78f64528e160459c81392b7d2a45a34c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Divide_78f64528e160459c81392b7d2a45a34c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            Unity_Smoothstep_float(0, 1, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3);
            surface.Alpha = _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
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
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
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
            float3 normalWS;
            float3 viewDirectionWS;
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
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 WorldSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
            float3 WorldSpacePosition;
            float3 TimeParameters;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float3 interp2 : TEXCOORD2;
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
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyz =  input.viewDirectionWS;
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
            output.normalWS = input.interp1.xyz;
            output.viewDirectionWS = input.interp2.xyz;
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
        float4 Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
        float Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
        float Vector1_6d024a442e4445a58392f940d9ca41eb;
        float Vector1_c00b63f6836648a7b404f63ff9065362;
        float4 Vector4_d8f745072ed34551b6fbab27ac15da6c;
        float4 Color_a8f6d59b451943b886190be35c4cdec4;
        float4 Color_827b3f2af1264ab790fcd641c03a1323;
        float Vector1_d93beab1dfdf47d0ac78237774641e04;
        float Vector1_e327f3b0e4ab48289380776fefe94635;
        float Vector1_ceec7645019a4eb3a3d10d983ab4817d;
        float Vector1_3800208a35b94be88cbefc54fa78eac4;
        float Vector1_d596022c25ce4d75a4c963ee0d8f4265;
        float Vector1_60b7d05b0dea41849d4f1e21bba834be;
        float Vector1_2c69c7860db641e596c8243fac652130;
        float Vector1_57735d99dc8d4e9e809d415002dc722c;
        float Vector1_ad077ce7c02a464b9a777f548adfc23a;
        float Vector1_15e77529abc84190897ffcf9ad860c74;
        float Vector1_0b48029a62c5496697a9c08b0ac7b682;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
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
            float _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2);
            float _Property_1d66ab0475594f69bda44245570f56fe_Out_0 = Vector1_57735d99dc8d4e9e809d415002dc722c;
            float _Divide_78d0724741b34bbda66a129545fde3cd_Out_2;
            Unity_Divide_float(_Distance_ddadd30a38c74dec8cb970523718fc48_Out_2, _Property_1d66ab0475594f69bda44245570f56fe_Out_0, _Divide_78d0724741b34bbda66a129545fde3cd_Out_2);
            float _Power_e62d01748d5142b981831d792c521de6_Out_2;
            Unity_Power_float(_Divide_78d0724741b34bbda66a129545fde3cd_Out_2, 3, _Power_e62d01748d5142b981831d792c521de6_Out_2);
            float3 _Multiply_831b6234304c4624973fb10dda220ee8_Out_2;
            Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_e62d01748d5142b981831d792c521de6_Out_2.xxx), _Multiply_831b6234304c4624973fb10dda220ee8_Out_2);
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float3 _Multiply_8a307d0314984df193f50bea862ea73f_Out_2;
            Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxx), _Multiply_8a307d0314984df193f50bea862ea73f_Out_2);
            float _Property_34bfc41539894c70af1f8e4106e10fe5_Out_0 = Vector1_c00b63f6836648a7b404f63ff9065362;
            float3 _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2;
            Unity_Multiply_float(_Multiply_8a307d0314984df193f50bea862ea73f_Out_2, (_Property_34bfc41539894c70af1f8e4106e10fe5_Out_0.xxx), _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2);
            float3 _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2);
            float3 _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            Unity_Add_float3(_Multiply_831b6234304c4624973fb10dda220ee8_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2, _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2);
            description.Position = _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_538e67f768b54c9492e39a41716da0be_Out_0 = Color_827b3f2af1264ab790fcd641c03a1323;
            float4 _Property_dca80baf2f544b908f8891da346aa5b2_Out_0 = Color_a8f6d59b451943b886190be35c4cdec4;
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float4 _Lerp_7b07d5aa22e847e89b0c7a55658da018_Out_3;
            Unity_Lerp_float4(_Property_538e67f768b54c9492e39a41716da0be_Out_0, _Property_dca80baf2f544b908f8891da346aa5b2_Out_0, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxxx), _Lerp_7b07d5aa22e847e89b0c7a55658da018_Out_3);
            float _Property_fc48609bbf27471da3a916d7dacde0b6_Out_0 = Vector1_ad077ce7c02a464b9a777f548adfc23a;
            float _FresnelEffect_c9efc5c6209547f7aa450492c217a29f_Out_3;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_fc48609bbf27471da3a916d7dacde0b6_Out_0, _FresnelEffect_c9efc5c6209547f7aa450492c217a29f_Out_3);
            float _Multiply_2d9bd770f6e14e8485da257c287635ca_Out_2;
            Unity_Multiply_float(_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2, _FresnelEffect_c9efc5c6209547f7aa450492c217a29f_Out_3, _Multiply_2d9bd770f6e14e8485da257c287635ca_Out_2);
            float _Property_3578aa3bf4e14a27a6928cdb85627563_Out_0 = Vector1_15e77529abc84190897ffcf9ad860c74;
            float _Multiply_eb587a30d3a045f6b566daeaffab4583_Out_2;
            Unity_Multiply_float(_Multiply_2d9bd770f6e14e8485da257c287635ca_Out_2, _Property_3578aa3bf4e14a27a6928cdb85627563_Out_0, _Multiply_eb587a30d3a045f6b566daeaffab4583_Out_2);
            float4 _Add_45bbe4f9380e4de6ba3a33b8835b0b38_Out_2;
            Unity_Add_float4(_Lerp_7b07d5aa22e847e89b0c7a55658da018_Out_3, (_Multiply_eb587a30d3a045f6b566daeaffab4583_Out_2.xxxx), _Add_45bbe4f9380e4de6ba3a33b8835b0b38_Out_2);
            float _Property_cde31309593140ef8d8e0107529b5fbd_Out_0 = Vector1_2c69c7860db641e596c8243fac652130;
            float4 _Multiply_8b669176027c45d09ca5773c1c4521b9_Out_2;
            Unity_Multiply_float(_Add_45bbe4f9380e4de6ba3a33b8835b0b38_Out_2, (_Property_cde31309593140ef8d8e0107529b5fbd_Out_0.xxxx), _Multiply_8b669176027c45d09ca5773c1c4521b9_Out_2);
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2;
            Unity_Subtract_float(_Split_6a3026dd6d88406e9fa3b06506538d75_A_4, 1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2);
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0 = Vector1_0b48029a62c5496697a9c08b0ac7b682;
            float _Divide_78f64528e160459c81392b7d2a45a34c_Out_2;
            Unity_Divide_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0, _Divide_78f64528e160459c81392b7d2a45a34c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Divide_78f64528e160459c81392b7d2a45a34c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            Unity_Smoothstep_float(0, 1, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3);
            surface.BaseColor = (_Multiply_8b669176027c45d09ca5773c1c4521b9_Out_2.xyz);
            surface.Alpha = _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
            output.TimeParameters =              _TimeParameters.xyz;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        	float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);


            output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph


            output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
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
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 WorldSpaceNormal;
            float3 ObjectSpaceTangent;
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
        float4 Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
        float Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
        float Vector1_6d024a442e4445a58392f940d9ca41eb;
        float Vector1_c00b63f6836648a7b404f63ff9065362;
        float4 Vector4_d8f745072ed34551b6fbab27ac15da6c;
        float4 Color_a8f6d59b451943b886190be35c4cdec4;
        float4 Color_827b3f2af1264ab790fcd641c03a1323;
        float Vector1_d93beab1dfdf47d0ac78237774641e04;
        float Vector1_e327f3b0e4ab48289380776fefe94635;
        float Vector1_ceec7645019a4eb3a3d10d983ab4817d;
        float Vector1_3800208a35b94be88cbefc54fa78eac4;
        float Vector1_d596022c25ce4d75a4c963ee0d8f4265;
        float Vector1_60b7d05b0dea41849d4f1e21bba834be;
        float Vector1_2c69c7860db641e596c8243fac652130;
        float Vector1_57735d99dc8d4e9e809d415002dc722c;
        float Vector1_ad077ce7c02a464b9a777f548adfc23a;
        float Vector1_15e77529abc84190897ffcf9ad860c74;
        float Vector1_0b48029a62c5496697a9c08b0ac7b682;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
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
            float _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2);
            float _Property_1d66ab0475594f69bda44245570f56fe_Out_0 = Vector1_57735d99dc8d4e9e809d415002dc722c;
            float _Divide_78d0724741b34bbda66a129545fde3cd_Out_2;
            Unity_Divide_float(_Distance_ddadd30a38c74dec8cb970523718fc48_Out_2, _Property_1d66ab0475594f69bda44245570f56fe_Out_0, _Divide_78d0724741b34bbda66a129545fde3cd_Out_2);
            float _Power_e62d01748d5142b981831d792c521de6_Out_2;
            Unity_Power_float(_Divide_78d0724741b34bbda66a129545fde3cd_Out_2, 3, _Power_e62d01748d5142b981831d792c521de6_Out_2);
            float3 _Multiply_831b6234304c4624973fb10dda220ee8_Out_2;
            Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_e62d01748d5142b981831d792c521de6_Out_2.xxx), _Multiply_831b6234304c4624973fb10dda220ee8_Out_2);
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float3 _Multiply_8a307d0314984df193f50bea862ea73f_Out_2;
            Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxx), _Multiply_8a307d0314984df193f50bea862ea73f_Out_2);
            float _Property_34bfc41539894c70af1f8e4106e10fe5_Out_0 = Vector1_c00b63f6836648a7b404f63ff9065362;
            float3 _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2;
            Unity_Multiply_float(_Multiply_8a307d0314984df193f50bea862ea73f_Out_2, (_Property_34bfc41539894c70af1f8e4106e10fe5_Out_0.xxx), _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2);
            float3 _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2);
            float3 _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            Unity_Add_float3(_Multiply_831b6234304c4624973fb10dda220ee8_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2, _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2);
            description.Position = _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2;
            Unity_Subtract_float(_Split_6a3026dd6d88406e9fa3b06506538d75_A_4, 1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2);
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0 = Vector1_0b48029a62c5496697a9c08b0ac7b682;
            float _Divide_78f64528e160459c81392b7d2a45a34c_Out_2;
            Unity_Divide_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0, _Divide_78f64528e160459c81392b7d2a45a34c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Divide_78f64528e160459c81392b7d2a45a34c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            Unity_Smoothstep_float(0, 1, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3);
            surface.Alpha = _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
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
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 WorldSpaceNormal;
            float3 ObjectSpaceTangent;
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
        float4 Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
        float Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
        float Vector1_6d024a442e4445a58392f940d9ca41eb;
        float Vector1_c00b63f6836648a7b404f63ff9065362;
        float4 Vector4_d8f745072ed34551b6fbab27ac15da6c;
        float4 Color_a8f6d59b451943b886190be35c4cdec4;
        float4 Color_827b3f2af1264ab790fcd641c03a1323;
        float Vector1_d93beab1dfdf47d0ac78237774641e04;
        float Vector1_e327f3b0e4ab48289380776fefe94635;
        float Vector1_ceec7645019a4eb3a3d10d983ab4817d;
        float Vector1_3800208a35b94be88cbefc54fa78eac4;
        float Vector1_d596022c25ce4d75a4c963ee0d8f4265;
        float Vector1_60b7d05b0dea41849d4f1e21bba834be;
        float Vector1_2c69c7860db641e596c8243fac652130;
        float Vector1_57735d99dc8d4e9e809d415002dc722c;
        float Vector1_ad077ce7c02a464b9a777f548adfc23a;
        float Vector1_15e77529abc84190897ffcf9ad860c74;
        float Vector1_0b48029a62c5496697a9c08b0ac7b682;
        CBUFFER_END

        // Object and Global properties

            // Graph Functions
            
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
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
            float _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_ddadd30a38c74dec8cb970523718fc48_Out_2);
            float _Property_1d66ab0475594f69bda44245570f56fe_Out_0 = Vector1_57735d99dc8d4e9e809d415002dc722c;
            float _Divide_78d0724741b34bbda66a129545fde3cd_Out_2;
            Unity_Divide_float(_Distance_ddadd30a38c74dec8cb970523718fc48_Out_2, _Property_1d66ab0475594f69bda44245570f56fe_Out_0, _Divide_78d0724741b34bbda66a129545fde3cd_Out_2);
            float _Power_e62d01748d5142b981831d792c521de6_Out_2;
            Unity_Power_float(_Divide_78d0724741b34bbda66a129545fde3cd_Out_2, 3, _Power_e62d01748d5142b981831d792c521de6_Out_2);
            float3 _Multiply_831b6234304c4624973fb10dda220ee8_Out_2;
            Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_e62d01748d5142b981831d792c521de6_Out_2.xxx), _Multiply_831b6234304c4624973fb10dda220ee8_Out_2);
            float _Property_076769b0bc2d411991381ac894ce238b_Out_0 = Vector1_d93beab1dfdf47d0ac78237774641e04;
            float _Property_7f37b508be844831bf8c03b68fb0f427_Out_0 = Vector1_e327f3b0e4ab48289380776fefe94635;
            float4 _Property_945e6dab577447eca40407a892458e76_Out_0 = Vector4_0bb0889ca2d24d0ba1526d1ace3b93c7;
            float _Split_2b618b1a821b477fb9c6507ed316580b_R_1 = _Property_945e6dab577447eca40407a892458e76_Out_0[0];
            float _Split_2b618b1a821b477fb9c6507ed316580b_G_2 = _Property_945e6dab577447eca40407a892458e76_Out_0[1];
            float _Split_2b618b1a821b477fb9c6507ed316580b_B_3 = _Property_945e6dab577447eca40407a892458e76_Out_0[2];
            float _Split_2b618b1a821b477fb9c6507ed316580b_A_4 = _Property_945e6dab577447eca40407a892458e76_Out_0[3];
            float3 _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_945e6dab577447eca40407a892458e76_Out_0.xyz), _Split_2b618b1a821b477fb9c6507ed316580b_A_4, _RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3);
            float _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0 = Vector1_6d024a442e4445a58392f940d9ca41eb;
            float _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_bb29dd26d7c8490389a5f5e2329d71cd_Out_0, _Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2);
            float2 _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_3681647ffdfe4f03bf725080a87de72f_Out_2.xx), _TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3);
            float _Property_7dbd562c898740309b3799360437c9d0_Out_0 = Vector1_eec6f57c1eb847e9afe01a2b71fefa9c;
            float _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_ddce9559cd394732a5e713c5d310bf20_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2);
            float2 _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3);
            float _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b2dc68feb441491d982bfd9257478eb2_Out_3, _Property_7dbd562c898740309b3799360437c9d0_Out_0, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2);
            float _Add_aab91d04e6b4404db18023434de482b9_Out_2;
            Unity_Add_float(_GradientNoise_d5c9491164604d21a86fc9e233c7e623_Out_2, _GradientNoise_ee354801cebe483f92b1ec85954acbda_Out_2, _Add_aab91d04e6b4404db18023434de482b9_Out_2);
            float _Divide_d63bc319d9ea4f39839a79954360317b_Out_2;
            Unity_Divide_float(_Add_aab91d04e6b4404db18023434de482b9_Out_2, 2, _Divide_d63bc319d9ea4f39839a79954360317b_Out_2);
            float _Saturate_111fd08858f04bf3b25526f161365f71_Out_1;
            Unity_Saturate_float(_Divide_d63bc319d9ea4f39839a79954360317b_Out_2, _Saturate_111fd08858f04bf3b25526f161365f71_Out_1);
            float _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0 = Vector1_ceec7645019a4eb3a3d10d983ab4817d;
            float _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2;
            Unity_Power_float(_Saturate_111fd08858f04bf3b25526f161365f71_Out_1, _Property_afe8a0bc7c18430a9a56a2e79f80617a_Out_0, _Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2);
            float4 _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0 = Vector4_d8f745072ed34551b6fbab27ac15da6c;
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_R_1 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[0];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[1];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_B_3 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[2];
            float _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4 = _Property_679578443aaa4149aadd4b5a1c9b39a6_Out_0[3];
            float4 _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4;
            float3 _Combine_5e17a00061e243ea903456e17e43d377_RGB_5;
            float2 _Combine_5e17a00061e243ea903456e17e43d377_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_R_1, _Split_57c81983a7d54f4bb2bb1887453c19a7_G_2, 0, 0, _Combine_5e17a00061e243ea903456e17e43d377_RGBA_4, _Combine_5e17a00061e243ea903456e17e43d377_RGB_5, _Combine_5e17a00061e243ea903456e17e43d377_RG_6);
            float4 _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4;
            float3 _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5;
            float2 _Combine_bfc87b29ca864c97b83936adc6643857_RG_6;
            Unity_Combine_float(_Split_57c81983a7d54f4bb2bb1887453c19a7_B_3, _Split_57c81983a7d54f4bb2bb1887453c19a7_A_4, 0, 0, _Combine_bfc87b29ca864c97b83936adc6643857_RGBA_4, _Combine_bfc87b29ca864c97b83936adc6643857_RGB_5, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6);
            float _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3;
            Unity_Remap_float(_Power_f4e3a41b67064caf8f22e85e9905fd2e_Out_2, _Combine_5e17a00061e243ea903456e17e43d377_RG_6, _Combine_bfc87b29ca864c97b83936adc6643857_RG_6, _Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3);
            float _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1;
            Unity_Absolute_float(_Remap_47c3cdc177bf4b6ea12e17e522807623_Out_3, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1);
            float _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3;
            Unity_Smoothstep_float(_Property_076769b0bc2d411991381ac894ce238b_Out_0, _Property_7f37b508be844831bf8c03b68fb0f427_Out_0, _Absolute_9537b36901714719a7f3d86a3e639c49_Out_1, _Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3);
            float _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0 = Vector1_d596022c25ce4d75a4c963ee0d8f4265;
            float _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_3210eddf86b0496f88cf4aa44f7da302_Out_0, _Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2);
            float2 _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3;
            Unity_TilingAndOffset_float((_RotateAboutAxis_07bb95751e7f41b3baffcc9e3e78a3ba_Out_3.xy), float2 (1, 1), (_Multiply_cc540c92aa824308ab327f8a5c64a085_Out_2.xx), _TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3);
            float _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0 = Vector1_3800208a35b94be88cbefc54fa78eac4;
            float _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2316ba9808374abe96374ab4bc2e4159_Out_3, _Property_479b03b8a5864370950bbf6ad5fc5bb4_Out_0, _GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2);
            float _Property_888de432c13640d68f794ce16534d50f_Out_0 = Vector1_60b7d05b0dea41849d4f1e21bba834be;
            float _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2;
            Unity_Multiply_float(_GradientNoise_13d068a9e79f4b759011318c567b7d60_Out_2, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2);
            float _Add_9556c3c443554332b69e6b098e280987_Out_2;
            Unity_Add_float(_Smoothstep_7b35309d2cf64f7d9375e02908973696_Out_3, _Multiply_f991b5b4704843c28ed112d7bb797075_Out_2, _Add_9556c3c443554332b69e6b098e280987_Out_2);
            float _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2;
            Unity_Add_float(1, _Property_888de432c13640d68f794ce16534d50f_Out_0, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2);
            float _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2;
            Unity_Divide_float(_Add_9556c3c443554332b69e6b098e280987_Out_2, _Add_cd5ede80806b4c39b70ebcd919edb291_Out_2, _Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2);
            float3 _Multiply_8a307d0314984df193f50bea862ea73f_Out_2;
            Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_06252cb0c2f34d68961bd26596bc24d3_Out_2.xxx), _Multiply_8a307d0314984df193f50bea862ea73f_Out_2);
            float _Property_34bfc41539894c70af1f8e4106e10fe5_Out_0 = Vector1_c00b63f6836648a7b404f63ff9065362;
            float3 _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2;
            Unity_Multiply_float(_Multiply_8a307d0314984df193f50bea862ea73f_Out_2, (_Property_34bfc41539894c70af1f8e4106e10fe5_Out_0.xxx), _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2);
            float3 _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_746289f06a0540ddb1fd48992cb44bef_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2);
            float3 _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            Unity_Add_float3(_Multiply_831b6234304c4624973fb10dda220ee8_Out_2, _Add_2ef7f2156cfb41989a1a4bd676a08a5b_Out_2, _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2);
            description.Position = _Add_51b54a4e6b6a46e39e63f7c7adae2378_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1);
            float4 _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0 = IN.ScreenPosition;
            float _Split_6a3026dd6d88406e9fa3b06506538d75_R_1 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[0];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_G_2 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[1];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_B_3 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[2];
            float _Split_6a3026dd6d88406e9fa3b06506538d75_A_4 = _ScreenPosition_6a36cb9622104f61b087e68efb69412a_Out_0[3];
            float _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2;
            Unity_Subtract_float(_Split_6a3026dd6d88406e9fa3b06506538d75_A_4, 1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2);
            float _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2;
            Unity_Subtract_float(_SceneDepth_1c56450d3490437bb27279ea5f0d9599_Out_1, _Subtract_acb4b9f8cbb84cd193d0ad7539ca8b9a_Out_2, _Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2);
            float _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0 = Vector1_0b48029a62c5496697a9c08b0ac7b682;
            float _Divide_78f64528e160459c81392b7d2a45a34c_Out_2;
            Unity_Divide_float(_Subtract_de9e35731caf41f8b61a83179cfe3d13_Out_2, _Property_14dfd60ccf7946ebb46daa7af9d52453_Out_0, _Divide_78f64528e160459c81392b7d2a45a34c_Out_2);
            float _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1;
            Unity_Saturate_float(_Divide_78f64528e160459c81392b7d2a45a34c_Out_2, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1);
            float _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            Unity_Smoothstep_float(0, 1, _Saturate_a503896ff681439d89c3c1892d8ea25f_Out_1, _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3);
            surface.Alpha = _Smoothstep_8ea3753a63f940f48cc73941626dfe11_Out_3;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
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
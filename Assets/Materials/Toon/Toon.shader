// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon"
{
	Properties
	{
		_MainTexture1("MainTexture", 2D) = "white" {}
		_Tint1("Tint", Color) = (1,1,1,1)
		[NoScaleOffset][Normal]_NormalMap1("NormalMap[", 2D) = "white" {}
		_BaseCellOffset1("BaseCellOffset", Range( -1 , 1)) = 0
		_BaseCellSharpness1("Base Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_ShadowContribuation1("ShadowContribuation", Range( 0 , 1)) = 0
		_IndirectDiffuseContribuation1("IndirectDiffuseContribuation", Range( 0 , 1)) = 0
		_OutlineColor1("OutlineColor", Color) = (0.4433962,0.4433962,0.4433962,0)
		_OutlineWidth1("OutlineWidth", Range( 0 , 0.2)) = 0.02
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _OutlineWidth1;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float2 uv_MainTexture1 = i.uv_texcoord * _MainTexture1_ST.xy + _MainTexture1_ST.zw;
			float4 tex2DNode36 = tex2D( _MainTexture1, uv_MainTexture1 );
			float temp_output_26_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap17 = i.uv_texcoord;
			float3 normalizeResult9 = normalize( (WorldNormalVector( i , tex2D( _NormalMap1, uv_NormalMap17 ).rgb )) );
			float3 Normals10 = normalizeResult9;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( Normals10 , ase_worldlightDir );
			float NDot14 = dotResult13;
			float lerpResult34 = lerp( temp_output_26_0 , ( saturate( ( ( NDot14 + _BaseCellOffset1 ) / _BaseCellSharpness1 ) ) * 1 ) , _ShadowContribuation1);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_2 = (1.0).xxx;
			float3 lerpResult32 = lerp( temp_cast_2 , float3(0,0,0) , _IndirectDiffuseContribuation1);
			float4 BaseColour43 = ( float4( (( tex2DNode36 * _Tint1 )).rgb , 0.0 ) * ( ( lerpResult34 * ase_lightColor ) + float4( ( temp_output_26_0 * ase_lightColor.a * lerpResult32 ) , 0.0 ) ) );
			o.Emission = ( BaseColour43 * float4( (_OutlineColor1).rgb , 0.0 ) ).rgb;
			o.Normal = float3(0,0,-1);
		}
		ENDCG
		

		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" }
		Cull Back
		Blend One Zero , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _MainTexture1;
		uniform float4 _MainTexture1_ST;
		uniform float4 _Tint1;
		uniform sampler2D _NormalMap1;
		uniform float _BaseCellOffset1;
		uniform float _BaseCellSharpness1;
		uniform float _ShadowContribuation1;
		uniform float _IndirectDiffuseContribuation1;
		SamplerState sampler_MainTexture1;
		uniform float4 _OutlineColor1;
		uniform float _OutlineWidth1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTexture1 = i.uv_texcoord * _MainTexture1_ST.xy + _MainTexture1_ST.zw;
			float4 tex2DNode36 = tex2D( _MainTexture1, uv_MainTexture1 );
			float AlphaBase48 = ( tex2DNode36.a * _Tint1.a );
			float temp_output_26_0 = ( 1.0 - ( ( 1.0 - ase_lightAtten ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap17 = i.uv_texcoord;
			float3 normalizeResult9 = normalize( (WorldNormalVector( i , tex2D( _NormalMap1, uv_NormalMap17 ).rgb )) );
			float3 Normals10 = normalizeResult9;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( Normals10 , ase_worldlightDir );
			float NDot14 = dotResult13;
			float lerpResult34 = lerp( temp_output_26_0 , ( saturate( ( ( NDot14 + _BaseCellOffset1 ) / _BaseCellSharpness1 ) ) * ase_lightAtten ) , _ShadowContribuation1);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_7 = (1.0).xxx;
			UnityGI gi28 = gi;
			float3 diffNorm28 = WorldNormalVector( i , Normals10 );
			gi28 = UnityGI_Base( data, 1, diffNorm28 );
			float3 indirectDiffuse28 = gi28.indirect.diffuse + diffNorm28 * 0.0001;
			float3 lerpResult32 = lerp( temp_cast_7 , indirectDiffuse28 , _IndirectDiffuseContribuation1);
			float4 BaseColour43 = ( float4( (( tex2DNode36 * _Tint1 )).rgb , 0.0 ) * ( ( lerpResult34 * ase_lightColor ) + float4( ( temp_output_26_0 * ase_lightColor.a * lerpResult32 ) , 0.0 ) ) );
			c.rgb = ( BaseColour43 + float4( 0,0,0,0 ) ).rgb;
			c.a = AlphaBase48;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_MainTexture1 = i.uv_texcoord * _MainTexture1_ST.xy + _MainTexture1_ST.zw;
			float4 tex2DNode36 = tex2D( _MainTexture1, uv_MainTexture1 );
			float temp_output_26_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap17 = i.uv_texcoord;
			float3 normalizeResult9 = normalize( (WorldNormalVector( i , tex2D( _NormalMap1, uv_NormalMap17 ).rgb )) );
			float3 Normals10 = normalizeResult9;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( Normals10 , ase_worldlightDir );
			float NDot14 = dotResult13;
			float lerpResult34 = lerp( temp_output_26_0 , ( saturate( ( ( NDot14 + _BaseCellOffset1 ) / _BaseCellSharpness1 ) ) * 1 ) , _ShadowContribuation1);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_2 = (1.0).xxx;
			float3 lerpResult32 = lerp( temp_cast_2 , float3(0,0,0) , _IndirectDiffuseContribuation1);
			float4 BaseColour43 = ( float4( (( tex2DNode36 * _Tint1 )).rgb , 0.0 ) * ( ( lerpResult34 * ase_lightColor ) + float4( ( temp_output_26_0 * ase_lightColor.a * lerpResult32 ) , 0.0 ) ) );
			o.Albedo = BaseColour43.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
69;196;1340;628;1643.547;1864.332;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-1102.666,1138.875;Inherit;False;1223.438;295.7039;Normals;5;10;9;8;7;6;;0,0.03644681,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;7;-770.0148,1200.739;Inherit;True;Property;_NormalMap1;NormalMap[;3;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;9b7f15a6aed32924c8c88384c2077a3b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;8;-484.0458,1205.846;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;9;-302.7068,1205.03;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;2;-1101.418,1487.267;Inherit;False;1158.959;419.7267;Dot;4;14;13;12;11;;1,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-131.5579,1198.512;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-1051.418,1537.267;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-1070.277,1742.82;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;13;-704.3948,1669.276;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-2241.474,-349.7401;Inherit;False;2667.431;1433.249;baseColour;27;52;48;47;43;42;41;40;39;38;37;36;35;34;33;31;30;26;24;23;22;21;20;19;18;17;16;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-366.0928,1685.823;Inherit;False;NDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-2138.992,-279.7281;Inherit;False;14;NDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2138.991,-87.77448;Inherit;False;Property;_BaseCellOffset1;BaseCellOffset;5;0;Create;True;0;0;False;0;False;0;0.27;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;17;-1950.994,64.29779;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1852.176,-52.22162;Inherit;False;Property;_BaseCellSharpness1;Base Cell Sharpness;6;0;Create;True;0;0;False;0;False;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1866.176,-217.2211;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-2077.543,-1226.742;Inherit;False;2491.822;791.9923;Indirect Diffuse;5;32;29;28;27;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-1620.176,-177.2211;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;21;-1941.211,264.0455;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;22;-1736.961,114.0724;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1653.538,233.0247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;-1435.531,-211.7921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2027.543,-1176.742;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1784.393,-1159.32;Inherit;False;Constant;_DefaultLight1;DefaultLight;8;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-1396.474,340.7363;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1772.078,-943.3531;Inherit;False;Property;_IndirectDiffuseContribuation1;IndirectDiffuseContribuation;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;28;-1772.304,-1064.28;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1892.804,417.9841;Inherit;False;Property;_ShadowContribuation1;ShadowContribuation;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1633.998,28.71252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;-1419.459,-1053.253;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;33;-1411.272,659.9452;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;34;-1402.353,504.4609;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-1404.163,137.8913;Inherit;False;Property;_Tint1;Tint;2;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-1481.606,-82.43457;Inherit;True;Property;_MainTexture1;MainTexture;1;0;Create;True;0;0;False;0;False;-1;None;bcc8fc05f1f924531a65f39394c0b703;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1130.044,600.7343;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1152.864,385.4936;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-970.9458,104.0791;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-777.7028,95.79858;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-934.6367,493.1155;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-622.5748,260.7114;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;5;-1347.84,-1899.73;Inherit;False;1625.367;577.8616;Comment;6;51;50;49;46;45;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-533.4048,99.69873;Inherit;False;BaseColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;44;-1292.504,-1719.644;Inherit;False;Property;_OutlineColor1;OutlineColor;9;0;Create;True;0;0;False;0;False;0.4433962,0.4433962,0.4433962,0;0.4433962,0.4433962,0.4433962,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;45;-1052.022,-1719.287;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1150.87,220.9468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1030.091,-1824.949;Inherit;False;43;BaseColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-813.0908,-1762.949;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1007.091,-1601.949;Inherit;False;Property;_OutlineWidth1;OutlineWidth;10;0;Create;True;0;0;False;0;False;0.02;0.19;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-967.6189,238.0038;Inherit;False;AlphaBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1061.477,1196.296;Inherit;False;Property;_FloatScale1;FloatScale;4;0;Create;True;0;0;False;0;False;0;0.411;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;51;-661.1578,-1693.281;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-251.8848,283.8876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;939.9757,-1271.055;Inherit;False;43;BaseColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;954.0547,-989.4479;Inherit;False;48;AlphaBase;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1273.761,-1211.118;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Toon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;9;0;8;0
WireConnection;10;0;9;0
WireConnection;13;0;12;0
WireConnection;13;1;11;0
WireConnection;14;0;13;0
WireConnection;19;0;16;0
WireConnection;19;1;15;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;22;0;17;0
WireConnection;23;0;22;0
WireConnection;23;1;21;2
WireConnection;24;0;20;0
WireConnection;26;0;23;0
WireConnection;28;0;25;0
WireConnection;31;0;24;0
WireConnection;31;1;17;0
WireConnection;32;0;27;0
WireConnection;32;1;28;0
WireConnection;32;2;29;0
WireConnection;34;0;26;0
WireConnection;34;1;31;0
WireConnection;34;2;30;0
WireConnection;38;0;26;0
WireConnection;38;1;33;2
WireConnection;38;2;32;0
WireConnection;37;0;34;0
WireConnection;37;1;33;0
WireConnection;39;0;36;0
WireConnection;39;1;35;0
WireConnection;40;0;39;0
WireConnection;41;0;37;0
WireConnection;41;1;38;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;43;0;42;0
WireConnection;45;0;44;0
WireConnection;47;0;36;4
WireConnection;47;1;35;4
WireConnection;50;0;46;0
WireConnection;50;1;45;0
WireConnection;48;0;47;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;52;0;43;0
WireConnection;0;0;53;0
WireConnection;0;9;54;0
WireConnection;0;13;52;0
WireConnection;0;11;51;0
ASEEND*/
//CHKSM=3418DFEEE3D8A5120F1EB0D0747AD6CEA4B0F0E2
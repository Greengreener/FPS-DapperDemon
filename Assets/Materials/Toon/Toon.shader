// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon"
{
	Properties
	{
		_MainTexture("MainTexture", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		[NoScaleOffset][Normal]_NormalMap("NormalMap[", 2D) = "white" {}
		_BaseCellOffset("BaseCellOffset", Range( -1 , 1)) = 0
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 4.4
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_BaseCellSharpness("Base Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_ShadowContribuation("ShadowContribuation", Range( 0 , 1)) = 0
		_IndirectDiffuseContribuation("IndirectDiffuseContribuation", Range( 0 , 1)) = 0
		_OutlineColor("OutlineColor", Color) = (0.4433962,0.4433962,0.4433962,0)
		_OutlineWidth("OutlineWidth", Range( 0 , 0.2)) = 0.02
		_HiglightTint("HiglightTint", Color) = (1,1,1,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_IndirectSpecularContribuation("Indirect Specular Contribuation", Range( 0 , 1)) = 0
		[Toggle(_STATICHIGHLIGHTS_ON)] _StaticHighlights("StaticHighlights", Float) = 0
		_HighLightCellSharpness("HighLightCellSharpness", Range( 0.001 , 1)) = 0.001
		_HighlightCellOffset("Highlight Cell Offset", Range( -1 , -0.5)) = -0.9081095
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		
		void outlineVertexDataFunc( inout appdata_full v )
		{
			float2 uv_MainTexture = v.texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode36 = tex2Dlod( _MainTexture, float4( uv_MainTexture, 0, 0.0) );
			float CustomOutlineWidth105 = tex2DNode36.a;
			float outlineVar = ( _OutlineWidth * CustomOutlineWidth105 );
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode36 = tex2D( _MainTexture, uv_MainTexture );
			float temp_output_26_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap7 = i.uv_texcoord;
			float3 normalizeResult9 = normalize( (WorldNormalVector( i , tex2D( _NormalMap, uv_NormalMap7 ).rgb )) );
			float3 Normals10 = normalizeResult9;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( Normals10 , ase_worldlightDir );
			float NDot14 = dotResult13;
			float lerpResult34 = lerp( temp_output_26_0 , ( saturate( ( ( NDot14 + _BaseCellOffset ) / _BaseCellSharpness ) ) * 1 ) , _ShadowContribuation);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_2 = (1.0).xxx;
			float3 lerpResult32 = lerp( temp_cast_2 , float3(0,0,0) , _IndirectDiffuseContribuation);
			float4 BaseColour43 = ( float4( (( tex2DNode36 * _Tint )).rgb , 0.0 ) * ( ( lerpResult34 * ase_lightColor ) + float4( ( temp_output_26_0 * ase_lightColor.a * lerpResult32 ) , 0.0 ) ) );
			o.Emission = ( BaseColour43 * float4( (_OutlineColor).rgb , 0.0 ) ).rgb;
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
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _STATICHIGHLIGHTS_ON
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

		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float4 _Tint;
		uniform sampler2D _NormalMap;
		uniform float _BaseCellOffset;
		uniform float _BaseCellSharpness;
		uniform float _ShadowContribuation;
		uniform float _IndirectDiffuseContribuation;
		SamplerState sampler_MainTexture;
		uniform float4 _HiglightTint;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _IndirectSpecularContribuation;
		uniform float _HighlightCellOffset;
		uniform float _HighLightCellSharpness;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;
		uniform float4 _OutlineColor;
		uniform float _OutlineWidth;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
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
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode36 = tex2D( _MainTexture, uv_MainTexture );
			float AlphaBase48 = ( tex2DNode36.a * _Tint.a );
			float3 temp_cast_5 = (1.0).xxx;
			float2 uv_NormalMap7 = i.uv_texcoord;
			float3 normalizeResult9 = normalize( (WorldNormalVector( i , tex2D( _NormalMap, uv_NormalMap7 ).rgb )) );
			float3 Normals10 = normalizeResult9;
			float3 indirectNormal70 = WorldNormalVector( i , Normals10 );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_63_0 = ( _HiglightTint * tex2D( _TextureSample0, uv_TextureSample0 ) );
			float Smoothness65 = (temp_output_63_0).a;
			Unity_GlossyEnvironmentData g70 = UnityGlossyEnvironmentSetup( Smoothness65, data.worldViewDir, indirectNormal70, float3(0,0,0));
			float3 indirectSpecular70 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal70, g70 );
			float3 lerpResult73 = lerp( temp_cast_5 , indirectSpecular70 , _IndirectSpecularContribuation);
			float3 indirectSpecular74 = lerpResult73;
			float3 HighlightColor81 = (temp_output_63_0).rgb;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 LightFalloff79 = ( ase_lightColor * ase_lightAtten );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g1 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult84 = dot( normalizeResult4_g1 , Normals10 );
			float dotResult13 = dot( Normals10 , ase_worldlightDir );
			float NDot14 = dotResult13;
			#ifdef _STATICHIGHLIGHTS_ON
				float staticSwitch85 = NDot14;
			#else
				float staticSwitch85 = dotResult84;
			#endif
			float CellShading95 = saturate( ( ( staticSwitch85 + _HighlightCellOffset ) / ( ( 1.0 - Smoothness65 ) * _HighLightCellSharpness ) ) );
			float4 Highlights103 = ( float4( indirectSpecular74 , 0.0 ) * float4( HighlightColor81 , 0.0 ) * LightFalloff79 * pow( Smoothness65 , 1.5 ) * CellShading95 );
			float temp_output_26_0 = ( 1.0 - ( ( 1.0 - ase_lightAtten ) * _WorldSpaceLightPos0.w ) );
			float lerpResult34 = lerp( temp_output_26_0 , ( saturate( ( ( NDot14 + _BaseCellOffset ) / _BaseCellSharpness ) ) * ase_lightAtten ) , _ShadowContribuation);
			float3 temp_cast_10 = (1.0).xxx;
			UnityGI gi28 = gi;
			float3 diffNorm28 = WorldNormalVector( i , Normals10 );
			gi28 = UnityGI_Base( data, 1, diffNorm28 );
			float3 indirectDiffuse28 = gi28.indirect.diffuse + diffNorm28 * 0.0001;
			float3 lerpResult32 = lerp( temp_cast_10 , indirectDiffuse28 , _IndirectDiffuseContribuation);
			float4 BaseColour43 = ( float4( (( tex2DNode36 * _Tint )).rgb , 0.0 ) * ( ( lerpResult34 * ase_lightColor ) + float4( ( temp_output_26_0 * ase_lightColor.a * lerpResult32 ) , 0.0 ) ) );
			float dotResult111 = dot( Normals10 , ase_worldViewDir );
			float4 color121 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 RimColour126 = ( ( saturate( NDot14 ) * pow( ( 1.0 - saturate( ( dotResult111 + 0.6 ) ) ) , 0.39 ) ) * float4( HighlightColor81 , 0.0 ) * LightFalloff79 * (color121).rgba );
			float4 FinalLighting58 = ( Highlights103 + BaseColour43 + RimColour126 );
			c.rgb = FinalLighting58.rgb;
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
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode36 = tex2D( _MainTexture, uv_MainTexture );
			float temp_output_26_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap7 = i.uv_texcoord;
			float3 normalizeResult9 = normalize( (WorldNormalVector( i , tex2D( _NormalMap, uv_NormalMap7 ).rgb )) );
			float3 Normals10 = normalizeResult9;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( Normals10 , ase_worldlightDir );
			float NDot14 = dotResult13;
			float lerpResult34 = lerp( temp_output_26_0 , ( saturate( ( ( NDot14 + _BaseCellOffset ) / _BaseCellSharpness ) ) * 1 ) , _ShadowContribuation);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_2 = (1.0).xxx;
			float3 lerpResult32 = lerp( temp_cast_2 , float3(0,0,0) , _IndirectDiffuseContribuation);
			float4 BaseColour43 = ( float4( (( tex2DNode36 * _Tint )).rgb , 0.0 ) * ( ( lerpResult34 * ase_lightColor ) + float4( ( temp_output_26_0 * ase_lightColor.a * lerpResult32 ) , 0.0 ) ) );
			o.Albedo = BaseColour43.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				vertexDataFunc( v );
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
-67;918;1340;622;2894.054;3297.801;3.523591;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-1102.666,1138.875;Inherit;False;1223.438;295.7039;Normals;5;10;9;8;7;6;;0,0.03644681,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;7;-770.0148,1200.739;Inherit;True;Property;_NormalMap;NormalMap[;3;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;9b7f15a6aed32924c8c88384c2077a3b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;8;-484.0458,1205.846;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;9;-302.7068,1205.03;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;2;-1101.418,1487.267;Inherit;False;1158.959;419.7267;Dot;4;14;13;12;11;;1,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-131.5579,1198.512;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;60;-3830.58,-3352.416;Inherit;False;2514.751;1320.485;Comment;28;94;93;91;63;85;84;83;61;86;62;80;87;89;90;82;81;88;92;66;95;96;97;98;99;100;101;102;103;HighLights;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-1051.418,1537.267;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-1070.277,1742.82;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;61;-3767.586,-3290.783;Inherit;False;Property;_HiglightTint;HiglightTint;16;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-3793.388,-3107.478;Inherit;True;Property;_TextureSample0;Texture Sample 0;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3410.388,-3128.478;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;66;-3244.18,-3284.977;Inherit;False;472.7852;166.1687;Comment;2;65;64;Spec/Smooth;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;13;-704.3948,1669.276;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-366.0928,1685.823;Inherit;False;NDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-2241.474,-349.7401;Inherit;False;2667.431;1433.249;baseColour;28;52;48;47;43;42;41;40;39;38;37;36;35;34;33;31;30;26;24;23;22;21;20;19;18;17;16;15;105;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;64;-3194.18,-3234.809;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-2995.395,-3234.977;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3756.223,-2750.244;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2138.991,-87.77448;Inherit;False;Property;_BaseCellOffset;BaseCellOffset;5;0;Create;True;0;0;False;0;False;0;0.27;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;-2580.094,-4212.083;Inherit;False;1840.555;590.0193;Comment;17;120;119;118;115;117;116;113;114;112;111;110;109;121;122;124;125;126;Rim Color;1,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-2138.992,-279.7281;Inherit;False;14;NDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;82;-3794.068,-2876.912;Inherit;False;Blinn-Phong Half Vector;-1;;1;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-3501.759,-2692.237;Inherit;False;14;NDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;17;-1950.994,64.29779;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1852.176,-52.22162;Inherit;False;Property;_BaseCellSharpness;Base Cell Sharpness;11;0;Create;True;0;0;False;0;False;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;84;-3492.009,-2837.373;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1866.176,-217.2211;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-2563.694,-4093.472;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;110;-2548.694,-3943.472;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;89;-3108.745,-2503.187;Inherit;False;65;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2939.344,-2304.618;Inherit;False;Property;_HighLightCellSharpness;HighLightCellSharpness;20;0;Create;True;0;0;False;0;False;0.001;0.35;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;90;-2815.674,-2560.389;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-1620.176,-177.2211;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3323.229,-2631.529;Inherit;False;Property;_HighlightCellOffset;Highlight Cell Offset;21;0;Create;True;0;0;False;0;False;-0.9081095;-0.9081095;-1;-0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;85;-3318.759,-2843.237;Inherit;False;Property;_StaticHighlights;StaticHighlights;19;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-2077.543,-1226.742;Inherit;False;2491.822;791.9923;Indirect Diffuse;5;32;29;28;27;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;21;-1941.211,264.0455;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;22;-1736.961,114.0724;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2407.209,-3756.795;Inherit;False;Constant;_RimOffset;Rim Offset;17;0;Create;True;0;0;False;0;False;0.6;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;111;-2299.694,-4094.472;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1268.844,-3315.382;Inherit;False;1367.526;455.4438;Comment;5;68;69;70;73;74;Indirect Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2027.543,-1176.742;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-1215.315,-3223.038;Inherit;False;10;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1211.553,-3057.696;Inherit;False;65;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-2943.214,-2711.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1653.538,233.0247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-2035.208,-3948.473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2557.002,-2428.986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;-1435.531,-211.7921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;443.8557,-3158.183;Inherit;False;1347.871;597.1152;Comment;4;77;78;79;76;Light Falloff;0.9716981,0.9239357,0,1;0;0
Node;AmplifyShaderEditor.IndirectSpecularLight;70;-924.501,-3120.123;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1772.078,-943.3531;Inherit;False;Property;_IndirectDiffuseContribuation;IndirectDiffuseContribuation;13;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-874.359,-3243.85;Inherit;False;Constant;_DefaultSpecular;DefaultSpecular;13;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;93;-2429.43,-2647.783;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-1396.474,340.7363;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1892.804,417.9841;Inherit;False;Property;_ShadowContribuation;ShadowContribuation;12;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1784.393,-1159.32;Inherit;False;Constant;_DefaultLight;DefaultLight;8;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;77;535.5383,-2825.289;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1633.998,28.71252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;114;-1912.782,-3933.406;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;28;-1772.304,-1064.28;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;76;546.3004,-3048.24;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;72;-922.359,-2943.85;Inherit;False;Property;_IndirectSpecularContribuation;Indirect Specular Contribuation;18;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-1402.353,504.4609;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1481.606,-82.43457;Inherit;True;Property;_MainTexture;MainTexture;1;0;Create;True;0;0;False;0;False;-1;None;bcc8fc05f1f924531a65f39394c0b703;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;33;-1411.272,659.9452;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;80;-3226.267,-3035.148;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;94;-2292.522,-2623.99;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;884.5387,-2949.289;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;-1419.459,-1053.253;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;35;-1404.163,137.8913;Inherit;False;Property;_Tint;Tint;2;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;-1915.797,-3838.859;Inherit;False;Constant;_RimPower;Rim Power;17;0;Create;True;0;0;False;0;False;0.39;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-1790.186,-3935.907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1801.914,-4036.193;Inherit;False;14;NDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;73;-569.359,-3135.85;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-2044.649,-2631.547;Inherit;False;CellShading;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;121;-1587.944,-3807.895;Inherit;False;Constant;_RimColour;Rim Colour;17;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2813.47,-2956.318;Inherit;False;65;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-3017.908,-3035.457;Inherit;False;HighlightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1152.864,385.4936;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;119;-1529.566,-4031.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-349.035,-3135.643;Inherit;False;indirectSpecular;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-970.9458,104.0791;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1130.044,600.7343;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;1097.524,-2957.88;Inherit;False;LightFalloff;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;117;-1533.565,-3927.159;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-934.6367,493.1155;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1301.944,-3966.895;Inherit;False;81;HighlightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;122;-1302.944,-3782.895;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1289.944,-3873.895;Inherit;False;79;LightFalloff;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1270.833,-4094.559;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2592.934,-3052.824;Inherit;False;79;LightFalloff;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-777.7028,95.79858;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2596.588,-3247.469;Inherit;False;74;indirectSpecular;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-2596.712,-3146.521;Inherit;False;81;HighlightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2573.081,-2812.722;Inherit;False;95;CellShading;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;101;-2559.979,-2941.575;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-1055.82,-3968.84;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-622.5748,260.7114;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-2295.235,-3049.682;Inherit;False;5;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;5;-1347.84,-1899.73;Inherit;False;1625.367;577.8616;Comment;8;51;50;49;46;45;44;106;107;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-533.4048,99.69873;Inherit;False;BaseColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-2082.476,-2980.646;Inherit;False;Highlights;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-927.8203,-3953.84;Inherit;False;RimColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;55;-958.184,-2242.705;Inherit;False;953;336;Comment;5;56;57;58;104;127;Final Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;44;-1292.504,-1719.644;Inherit;False;Property;_OutlineColor;OutlineColor;14;0;Create;True;0;0;False;0;False;0.4433962,0.4433962,0.4433962,0;0.4433962,0.4433962,0.4433962,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;-909.2719,-2046.349;Inherit;False;43;BaseColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-1047.2,-72.63272;Inherit;False;CustomOutlineWidth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-758.6071,-1988.36;Inherit;False;126;RimColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-902.8486,-2173.074;Inherit;False;103;Highlights;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1150.87,220.9468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1030.091,-1824.949;Inherit;False;43;BaseColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-509.5815,-2136.459;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1007.091,-1601.949;Inherit;False;Property;_OutlineWidth;OutlineWidth;15;0;Create;True;0;0;False;0;False;0.02;0.19;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-1019.874,-1476.672;Inherit;False;105;CustomOutlineWidth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;45;-1052.022,-1719.287;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-967.6189,238.0038;Inherit;False;AlphaBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-813.0908,-1762.949;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-279.4495,-2120.124;Inherit;False;FinalLighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-734.2577,-1508.092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;653.9911,-1807.328;Inherit;False;48;AlphaBase;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-251.8848,283.8876;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;618.9933,-2042.151;Inherit;False;43;BaseColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;51;-661.1578,-1693.281;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1061.477,1196.296;Inherit;False;Property;_FloatScale;FloatScale;4;0;Create;True;0;0;False;0;False;0;0.411;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;653.4358,-1741.134;Inherit;False;58;FinalLighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1030.451,-1980.326;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;Toon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;4.4;10;25;True;0.5;True;0;0;False;-1;0;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;6;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;9;0;8;0
WireConnection;10;0;9;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;13;0;12;0
WireConnection;13;1;11;0
WireConnection;14;0;13;0
WireConnection;64;0;63;0
WireConnection;65;0;64;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;19;0;16;0
WireConnection;19;1;15;0
WireConnection;90;0;89;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;85;1;84;0
WireConnection;85;0;86;0
WireConnection;22;0;17;0
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;88;0;85;0
WireConnection;88;1;87;0
WireConnection;23;0;22;0
WireConnection;23;1;21;2
WireConnection;113;0;111;0
WireConnection;113;1;112;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;24;0;20;0
WireConnection;70;0;68;0
WireConnection;70;1;69;0
WireConnection;93;0;88;0
WireConnection;93;1;92;0
WireConnection;26;0;23;0
WireConnection;31;0;24;0
WireConnection;31;1;17;0
WireConnection;114;0;113;0
WireConnection;28;0;25;0
WireConnection;34;0;26;0
WireConnection;34;1;31;0
WireConnection;34;2;30;0
WireConnection;80;0;63;0
WireConnection;94;0;93;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;32;0;27;0
WireConnection;32;1;28;0
WireConnection;32;2;29;0
WireConnection;115;0;114;0
WireConnection;73;0;71;0
WireConnection;73;1;70;0
WireConnection;73;2;72;0
WireConnection;95;0;94;0
WireConnection;81;0;80;0
WireConnection;37;0;34;0
WireConnection;37;1;33;0
WireConnection;119;0;118;0
WireConnection;74;0;73;0
WireConnection;39;0;36;0
WireConnection;39;1;35;0
WireConnection;38;0;26;0
WireConnection;38;1;33;2
WireConnection;38;2;32;0
WireConnection;79;0;78;0
WireConnection;117;0;115;0
WireConnection;117;1;116;0
WireConnection;41;0;37;0
WireConnection;41;1;38;0
WireConnection;122;0;121;0
WireConnection;120;0;119;0
WireConnection;120;1;117;0
WireConnection;40;0;39;0
WireConnection;101;0;99;0
WireConnection;125;0;120;0
WireConnection;125;1;123;0
WireConnection;125;2;124;0
WireConnection;125;3;122;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;102;0;96;0
WireConnection;102;1;97;0
WireConnection;102;2;98;0
WireConnection;102;3;101;0
WireConnection;102;4;100;0
WireConnection;43;0;42;0
WireConnection;103;0;102;0
WireConnection;126;0;125;0
WireConnection;105;0;36;4
WireConnection;47;0;36;4
WireConnection;47;1;35;4
WireConnection;57;0;104;0
WireConnection;57;1;56;0
WireConnection;57;2;127;0
WireConnection;45;0;44;0
WireConnection;48;0;47;0
WireConnection;50;0;46;0
WireConnection;50;1;45;0
WireConnection;58;0;57;0
WireConnection;107;0;49;0
WireConnection;107;1;106;0
WireConnection;52;0;43;0
WireConnection;51;0;50;0
WireConnection;51;1;107;0
WireConnection;0;0;53;0
WireConnection;0;9;54;0
WireConnection;0;13;59;0
WireConnection;0;11;51;0
ASEEND*/
//CHKSM=9E98CD2915571028D0D1958A8F59E951A212EB48
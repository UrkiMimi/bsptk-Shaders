// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Urki/Sprite"
{
	Properties
	{
		_MainTex("MainTexture", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_FogOffset("Fog Offset", Float) = 0
		_FogScale("Fog Scale", Float) = 0
		[Enum(Off,0,On,1)][Off][On]_Glow("Glow", Int) = 0
		_FactorOffset("Factor Offset", Int) = 0
		[Toggle(MAIN_EFFECT_OVERRIDE)] _OverrideMainEffect("Override Main Effect Settings", Float) = 0
		[ToggleUI]_UseCutout("Use Cutout", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha , [_Glow] OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature ENABLE_CENTER_CUTOUT_GLOBAL
		#pragma shader_feature_local MAIN_EFFECT_OVERRIDE
		#pragma shader_feature MAIN_EFFECT_ENABLED
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float eyeDepth;
		};

		uniform float _UseCutout;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform int _Glow;
		uniform int _FactorOffset;
		uniform float _CustomFogAttenuation;
		uniform float _FogOffset;
		uniform float _CustomFogOffset;
		uniform float _FogScale;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			#ifdef ENABLE_CENTER_CUTOUT_GLOBAL
				float3 staticSwitch44 = ( ase_vertex3Pos * float3( 0,0,0 ) );
			#else
				float3 staticSwitch44 = ase_vertex3Pos;
			#endif
			v.vertex.xyz = (( _UseCutout )?( staticSwitch44 ):( ase_vertex3Pos ));
			v.vertex.w = 1;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			#ifdef MAIN_EFFECT_ENABLED
				float staticSwitch41 = (float)( 0 * _Glow );
			#else
				float staticSwitch41 = (float)_Glow;
			#endif
			#ifdef MAIN_EFFECT_OVERRIDE
				float staticSwitch43 = 0.0;
			#else
				float staticSwitch43 = staticSwitch41;
			#endif
			o.Emission = ( ( i.vertexColor * tex2DNode1 * _Color ) + staticSwitch43 + ( 0 * _FactorOffset ) ).rgb;
			float clampResult23 = clamp( ( ( ( i.eyeDepth * _CustomFogAttenuation ) - ( _FogOffset + _CustomFogOffset ) ) / _FogScale ) , 0.0 , 1.0 );
			o.Alpha = ( i.vertexColor.a * tex2DNode1.a * _Color.a * ( 1.0 - clampResult23 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;600;1164;391;1401.265;222.1227;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;24;-1219.13,68.81084;Inherit;False;Global;_CustomFogOffset;_CustomFogOffset;7;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;17;-1185.57,-153.3928;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1204.13,-72.18919;Inherit;False;Global;_CustomFogAttenuation;_CustomFogAttenuation;7;0;Create;True;0;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1130.782,-3.370193;Inherit;False;Property;_FogOffset;Fog Offset;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-877.13,-145.1892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-905.13,-34.18919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-726.782,-47.37019;Inherit;False;Property;_FogScale;Fog Scale;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;36;-1398.56,158.7696;Inherit;False;Property;_Glow;Glow;5;1;[Enum];Create;True;0;2;Off;0;On;1;0;False;2;Off;On;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-729.782,-148.3702;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;46;-892.0583,398.4142;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-547.782,-117.3702;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1202.441,180.4214;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;41;-1050.643,165.5016;Inherit;False;Property;_MainEffectEnabled;Main Effect Enabled;7;0;Create;True;0;0;0;False;0;False;0;0;0;False;MAIN_EFFECT_ENABLED;Toggle;2;Key0;Key1;Create;False;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;2;-233,-160.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-629.3197,483.737;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;23;-379.782,-140.3702;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-305,191.5;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-354,-2.5;Inherit;True;Property;_MainTex;MainTexture;1;0;Create;False;0;0;0;False;0;False;-1;None;2f2d5531a4debf345983d2aad62da6b3;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;38;-743,146.5;Inherit;False;Property;_FactorOffset;Factor Offset;6;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-234,-237.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;43;-700.4388,31.30376;Inherit;False;Property;_OverrideMainEffect;Override Main Effect Settings;7;0;Create;False;0;0;0;False;0;False;0;0;1;True;MAIN_EFFECT_OVERRIDE;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;44;-309.6042,389.223;Inherit;False;Property;_CenterCutout;Center Cutout;20;0;Create;True;0;0;0;False;0;False;0;0;0;False;ENABLE_CENTER_CUTOUT_GLOBAL;Toggle;2;Key0;Key1;Create;False;False;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-507,154.5;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;36,-165.5;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;47;46.0408,354.5416;Inherit;False;Property;_UseCutout;Use Cutout;8;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;33,-39.5;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;202.2,-170.1;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1.164785,-443.1228;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;700.6002,-213.1999;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Urki/Sprite;False;False;False;False;True;True;True;True;True;True;False;False;False;False;False;True;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;1;True;38;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;1;0;True;36;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;18;0;15;0
WireConnection;18;1;24;0
WireConnection;21;0;19;0
WireConnection;21;1;18;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;28;1;36;0
WireConnection;41;1;36;0
WireConnection;41;0;28;0
WireConnection;45;0;46;0
WireConnection;23;0;22;0
WireConnection;25;0;23;0
WireConnection;43;1;41;0
WireConnection;44;1;46;0
WireConnection;44;0;45;0
WireConnection;39;1;38;0
WireConnection;5;0;2;0
WireConnection;5;1;1;0
WireConnection;5;2;6;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;7;0;2;4
WireConnection;7;1;1;4
WireConnection;7;2;6;4
WireConnection;7;3;25;0
WireConnection;29;0;5;0
WireConnection;29;1;43;0
WireConnection;29;2;39;0
WireConnection;0;2;29;0
WireConnection;0;9;7;0
WireConnection;0;11;47;0
ASEEND*/
//CHKSM=92EE94E3EF14AD035AA4777F9F7D8D156F43F1A4
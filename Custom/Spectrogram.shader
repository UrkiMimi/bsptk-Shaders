// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Urki/Spectrogram"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_FogOffset("Fog Offset", Float) = 0
		_FogScale("Fog Scale", Float) = 0
		_FogClamp("FogClamp", Vector) = (0,0,0,0)
		_FresnelVector("FresnelVector", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Stencil
		{
			Ref 255
			Comp Always
			Pass Keep
			Fail Keep
			ZFail Keep
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 5.0
		#pragma vertex vert
		#pragma multi_compile_fog
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float eyeDepth;
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform sampler2D _DataTex;
		uniform float4 _DataTex_ST;
		uniform sampler2D _BloomPrePassTexture;
		uniform float4 _CustomFogColor;
		uniform float _CustomFogColorMultiplier;
		uniform float _CustomFogAttenuation;
		uniform float _FogOffset;
		uniform float _CustomFogOffset;
		uniform float _FogScale;
		uniform float2 _FogClamp;
		uniform float3 _FresnelVector;
		uniform float4 _Color;


		float3 VertexFunnies89( float redCh, float3 vertexPos )
		{
			float3 v = vertexPos;
			v.z = v.z * redCh;
			return v;
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float2 MyCustomExpression80( float2 input )
		{
			#ifdef UNITY_UV_STARTS_AT_TOP
			{
			}
			#else
			{
				input.y = 1 - input.y;
			}
			#endif
			return input;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_DataTex = v.texcoord * _DataTex_ST.xy + _DataTex_ST.zw;
			float4 tex2DNode81 = tex2Dlod( _DataTex, float4( uv_DataTex, 0, 0.0) );
			float redCh89 = ( 1.0 - tex2DNode81.r );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos89 = ase_vertex3Pos;
			float3 localVertexFunnies89 = VertexFunnies89( redCh89 , vertexPos89 );
			v.vertex.xyz = localVertexFunnies89;
			v.vertex.w = 1;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 input80 = ase_grabScreenPosNorm.xy;
			float2 localMyCustomExpression80 = MyCustomExpression80( input80 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV54 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode54 = ( _FresnelVector.x + _FresnelVector.y * pow( 1.0 - fresnelNdotV54, _FresnelVector.z ) );
			float clampResult15 = clamp( ( ( ( i.eyeDepth * _CustomFogAttenuation ) - ( _FogOffset + _CustomFogOffset ) ) / _FogScale ) , ( _FogClamp.x * ( 1.0 - fresnelNode54 ) ) , _FogClamp.y );
			float temp_output_19_0 = ( 1.0 - clampResult15 );
			float2 uv_DataTex = i.uv_texcoord * _DataTex_ST.xy + _DataTex_ST.zw;
			float4 tex2DNode81 = tex2D( _DataTex, uv_DataTex );
			o.Emission = ( ( ( tex2D( _BloomPrePassTexture, localMyCustomExpression80 ) + ( _CustomFogColor * _CustomFogColorMultiplier ) ) * clampResult15 ) + ( temp_output_19_0 * _Color ) + ( 1.0 - tex2DNode81 ) ).rgb;
			o.Alpha = ( temp_output_19_0 * _Color.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
263;26;1273;715;841.4797;170.7049;1.060001;True;True
Node;AmplifyShaderEditor.Vector3Node;56;-1419.848,57.181;Inherit;False;Property;_FresnelVector;FresnelVector;7;0;Create;True;0;0;0;False;0;False;0,0,0;0,1,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;11;-1337.5,-168;Inherit;False;Property;_FogOffset;Fog Offset;4;0;Create;True;0;0;0;False;0;False;0;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1410.848,-236.819;Inherit;False;Global;_CustomFogAttenuation;_CustomFogAttenuation;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1425.848,-95.81897;Inherit;False;Global;_CustomFogOffset;_CustomFogOffset;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;52;-1392.288,-318.0226;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-1111.848,-198.819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1083.848,-309.819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;54;-1211.848,40.181;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;53;-992.848,-100.819;Inherit;False;Property;_FogClamp;FogClamp;6;0;Create;True;0;0;0;False;0;False;0,0;0.1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-936.5,-313;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-983.848,15.181;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-933.5,-212;Inherit;False;Property;_FogScale;Fog Scale;5;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;78;-766.348,4.681;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;80;-453.5179,-60.14279;Inherit;False;#ifdef UNITY_UV_STARTS_AT_TOP${$}$#else${$	input.y = 1 - input.y@$}$#endif$return input@;2;Create;1;True;input;FLOAT2;0,0;In;;Inherit;False;My Custom Expression;True;False;0;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-767.848,-110.819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-426.848,-234.819;Inherit;False;Global;_CustomFogColorMultiplier;_CustomFogColorMultiplier;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;62;-409.848,-407.819;Inherit;False;Global;_CustomFogColor;_CustomFogColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;17;-754.5,-282;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-244.5,-156;Inherit;True;Global;_BloomPrePassTexture;_BloomPrePassTexture;0;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-139.848,-257.819;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;15;-560.5,-297;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-149.5,-326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-625.0181,256.0572;Inherit;True;Global;_DataTex;_DataTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-383.5,32;Inherit;False;Property;_Color;Color;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;90.15198,-146.819;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;90;-305.6491,300.9954;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;291.5,-168;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;291.5,-72;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;83;-329.778,429.4172;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;91;-298.2292,227.8555;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;89;-40.19028,288.2755;Inherit;False;float3 v = vertexPos@$v.z = v.z * redCh@$return v@;3;Create;2;True;redCh;FLOAT;0;In;;Inherit;False;True;vertexPos;FLOAT3;0,0,0;In;;Inherit;False;Vertex Funnies;True;False;0;;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;442.5,-166;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;279.7085,23.07257;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;645,-221;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;Urki/Spectrogram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Opaque;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;True;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;2;Pragma;vertex vert;False;;Custom;Pragma;multi_compile_fog;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;0;11;0
WireConnection;60;1;61;0
WireConnection;58;0;52;0
WireConnection;58;1;59;0
WireConnection;54;1;56;1
WireConnection;54;2;56;2
WireConnection;54;3;56;3
WireConnection;16;0;58;0
WireConnection;16;1;60;0
WireConnection;57;0;54;0
WireConnection;80;0;78;0
WireConnection;55;0;53;1
WireConnection;55;1;57;0
WireConnection;17;0;16;0
WireConnection;17;1;12;0
WireConnection;1;1;80;0
WireConnection;64;0;62;0
WireConnection;64;1;65;0
WireConnection;15;0;17;0
WireConnection;15;1;55;0
WireConnection;15;2;53;2
WireConnection;19;0;15;0
WireConnection;63;0;1;0
WireConnection;63;1;64;0
WireConnection;90;0;81;1
WireConnection;14;0;63;0
WireConnection;14;1;15;0
WireConnection;18;0;19;0
WireConnection;18;1;9;0
WireConnection;91;0;81;0
WireConnection;89;0;90;0
WireConnection;89;1;83;0
WireConnection;20;0;14;0
WireConnection;20;1;18;0
WireConnection;20;2;91;0
WireConnection;51;0;19;0
WireConnection;51;1;9;4
WireConnection;0;2;20;0
WireConnection;0;9;51;0
WireConnection;0;11;89;0
ASEEND*/
//CHKSM=5218E201AF6B7C2A07153C5249A478D9016C45E3
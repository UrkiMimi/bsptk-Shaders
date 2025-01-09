// Upgrade NOTE: upgraded instancing buffer 'UrkiParametric3SliceSprite' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Urki/Parametric3SliceSprite"
{
	Properties
	{
		_Color("Tint Color", Color) = (1,0,0,1)
		_SizeParams("Size Length and Center", Vector) = (0.2,2,0.5,0)
		_MainTex("Sprite Texture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Stencil
		{
			Ref 0
			CompFront Always
			PassFront Keep
			FailFront Keep
			ZFailFront Keep
		}
		Blend One One , One One
		
		CGPROGRAM
		#pragma target 5.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;

		UNITY_INSTANCING_BUFFER_START(UrkiParametric3SliceSprite)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr UrkiParametric3SliceSprite
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr UrkiParametric3SliceSprite
			UNITY_DEFINE_INSTANCED_PROP(float3, _SizeParams)
#define _SizeParams_arr UrkiParametric3SliceSprite
		UNITY_INSTANCING_BUFFER_END(UrkiParametric3SliceSprite)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 _SizeParams_Instance = UNITY_ACCESS_INSTANCED_PROP(_SizeParams_arr, _SizeParams);
			v.vertex.xyz = ( float3( 0,0,0 ) + ( ( float3(1,0,0) * ( ase_vertex3Pos.x * _SizeParams_Instance.x ) ) + ( float3(0,1,0) * ( ( ase_vertex3Pos.y - _SizeParams_Instance.z ) * _SizeParams_Instance.y ) ) + ( float3(0,0,1) * ( _SizeParams_Instance.x * ase_vertex3Pos.z ) ) ) );
			v.vertex.w = 1;
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float4 tex2DNode28 = tex2D( _MainTex, uv_MainTex );
			o.Emission = ( _Color_Instance * tex2DNode28 * tex2DNode28.a * _Color_Instance.a ).rgb;
			o.Alpha = ( tex2DNode28 * tex2DNode28.a * _Color_Instance.a ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;0;1536;795;617.8086;-234.7758;1.215397;True;False
Node;AmplifyShaderEditor.CommentaryNode;32;-932,21.3411;Inherit;False;1214.404;497.7589;Vertex stuff;11;18;25;26;27;24;23;15;9;5;3;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;3;-889.8574,267.3231;Inherit;False;InstancedProperty;_SizeParams;Size Length and Center;1;0;Create;False;0;0;0;False;0;False;0.2,2,0.5;1,1.03,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;5;-923.446,90.41129;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;14;-1100,-412;Inherit;False;542.8;235.6;Amplify component mask is retarded;3;11;20;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-633.4827,185.6289;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;19;-1060.796,-351.6589;Inherit;False;Constant;_Red;Red;2;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-482.7961,170.8411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-475.796,72.34109;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-476.796,267.3411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;11;-893,-350;Inherit;False;Constant;_Green;Green;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;20;-732.796,-348.6589;Inherit;False;Constant;_Blue;Blue;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-348.796,167.3411;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-348.796,71.34109;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-340.796,266.3411;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-180.7961,125.8411;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;2;-52,-413.5;Inherit;False;InstancedProperty;_Color;Tint Color;0;0;Create;False;0;0;0;True;0;False;1,0,0,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-190.796,-247.1589;Inherit;True;Property;_MainTex;Sprite Texture;3;0;Create;False;0;0;0;False;0;False;-1;None;0000000000000000f000000000000000;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;198.9498,-372.2058;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;151.9498,103.7942;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;195.204,-228.6589;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-772.796,-567.1589;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;654,-374;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;Urki/Parametric3SliceSprite;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;False;False;Absolute;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;5;2
WireConnection;9;1;3;3
WireConnection;15;0;9;0
WireConnection;15;1;3;2
WireConnection;23;0;5;1
WireConnection;23;1;3;1
WireConnection;24;0;3;1
WireConnection;24;1;5;3
WireConnection;26;0;11;0
WireConnection;26;1;15;0
WireConnection;25;0;19;0
WireConnection;25;1;23;0
WireConnection;27;0;20;0
WireConnection;27;1;24;0
WireConnection;18;0;25;0
WireConnection;18;1;26;0
WireConnection;18;2;27;0
WireConnection;35;0;2;0
WireConnection;35;1;28;0
WireConnection;35;2;28;4
WireConnection;35;3;2;4
WireConnection;34;1;18;0
WireConnection;29;0;28;0
WireConnection;29;1;28;4
WireConnection;29;2;2;4
WireConnection;0;2;35;0
WireConnection;0;9;29;0
WireConnection;0;11;34;0
ASEEND*/
//CHKSM=63A8E88F57D06261827C39E1CB26AC3BF70C5B3E
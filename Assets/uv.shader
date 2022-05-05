Shader "Custom/uv"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            // o.Albedo = c.rgb;

            // 버텍스로부터 넘어온 uv좌표인 uv_MainTex 의 x좌표, 즉 u좌표가 어떻게 변하는지 시각화하려는 것. 
            // u좌표는 x좌표처럼 왼쪽 -> 오른쪽 방향으로 0 ~ 1 로 증가하므로, 
            // 왼쪽 ~ 오른쪽 방향으로 float3(0, 0, 0) ~ float3(1, 1, 1) 즉, 검정색 ~ 흰색 사이의 색상값이 할당될거임. 
            // o.Emission = IN.uv_MainTex.x;

            // 이번엔 v좌표가 어떻게 변하는지 시각화하려는 것. 
            // v좌표는 유니티 및 opengl 기준 아래쪽 -> 위쪽 방향으로 0 ~ 1 로 증가하므로, 
            // 아래쪽 ~ 위쪽 방향으로 float3(0, 0, 0) ~ float3(1, 1, 1) 즉, 검정색 ~ 흰색 사이의 색상값이 할당될거임. 
            // o.Emission = IN.uv_MainTex.y;

            // 이번에는 u좌표를 R값에, v좌표를 G값에 넣어서 두 좌표의 변화를 동시에 시각화한 것.
            // 우측으로 갈수록 R값이 1에 가까워질테니 빨간색이 더 강해지고,
            // 상단으로 갈수록 G값이 1에 가까워질테니 초록색이 더 강해짐.
            // 우측 상단으로 갈수록 R, G 가 동시에 1에 가까워질테니 빨강과 초록의 합산인 노란색이 더 강해짐.
            o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0.0);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "Custom/uv"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FlowSpeed ("Flow Speed", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        float _FlowSpeed;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // fixed4 c = tex2D (_MainTex, IN.uv_MainTex + 0.5); // uv좌표에 특정 값을 더하면, 이미지(즉 텍스쳐)가 이동한다는 것을 알 수 있음. -> 유니티에서 Wrap mode 를 Repeat 으로 설정하면 그렇고, clamp로 설정하면 가장자리 픽셀이 늘어나게 됨! -> webgl 할 때 배운 내용임!
            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex + _Time.y); // uv좌표에 유니티 시간 관련 내장변수인 _Time 을 더해주고, Scene 에서 'Always Refresh' 를 체크하거나 play 버튼을 누르면 텍스쳐가 왼쪽 아래로 이동하는 애니메이션이 만들어짐! -> _Time 변수의 xyzw 값 관련 설명은 p.172 참고 
            // 참고로, Always Refresh 로 활성화하건, play 버튼을 클릭하건, 애니메이션이 유니티에서 재생되기만 하면 유니티로 만든 게임에서 사용할 수 있다는 뜻임!
            // fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x + _Time.y, IN.uv_MainTex.y)); // uv좌표는 본질적으로 float2 값이므로, uv좌표의 u값, 즉 x값에만 _Time 을 더해주면 x방향으로만 흘러가게 할 수도 있음.
            // fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x, IN.uv_MainTex.y + _Time.y)); // 이거는 v값에 더해주고 있으니 y방향으로만 흘러가게 하는 거지!
            fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x, IN.uv_MainTex.y + _Time.y * _FlowSpeed)); // 인터페이스에서 float 타입의 속도값을 받아와서, _FlowSpeed 변수에 저장한 뒤 _Time 값에 곱해주면 애니메이션 속도 제어 가능! 

            o.Albedo = c.rgb;

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
            // o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0.0);
            
            // o.Emission = float3(_CosTime.w, _SinTime.w, 0); // Sin 그래프 및 Cos 그래프의 시간값만 가져와서 색상의 R, G 값에 각각 넣어 시각화한 애니메이션
            // o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y + _SinTime.w, 0); // Sin 그래프의 시간값 (즉, -1 ~ 1 사이를 왕복하는 값)을 uv의 v값에 더해주고, 그 값을 색상의 G값에 넣어서 시각화한 애니메이션 
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

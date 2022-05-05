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

            // ���ؽ��κ��� �Ѿ�� uv��ǥ�� uv_MainTex �� x��ǥ, �� u��ǥ�� ��� ���ϴ��� �ð�ȭ�Ϸ��� ��. 
            // u��ǥ�� x��ǥó�� ���� -> ������ �������� 0 ~ 1 �� �����ϹǷ�, 
            // ���� ~ ������ �������� float3(0, 0, 0) ~ float3(1, 1, 1) ��, ������ ~ ��� ������ ������ �Ҵ�ɰ���. 
            // o.Emission = IN.uv_MainTex.x;

            // �̹��� v��ǥ�� ��� ���ϴ��� �ð�ȭ�Ϸ��� ��. 
            // v��ǥ�� ����Ƽ �� opengl ���� �Ʒ��� -> ���� �������� 0 ~ 1 �� �����ϹǷ�, 
            // �Ʒ��� ~ ���� �������� float3(0, 0, 0) ~ float3(1, 1, 1) ��, ������ ~ ��� ������ ������ �Ҵ�ɰ���. 
            // o.Emission = IN.uv_MainTex.y;

            // �̹����� u��ǥ�� R����, v��ǥ�� G���� �־ �� ��ǥ�� ��ȭ�� ���ÿ� �ð�ȭ�� ��.
            // �������� ������ R���� 1�� ��������״� �������� �� ��������,
            // ������� ������ G���� 1�� ��������״� �ʷϻ��� �� ������.
            // ���� ������� ������ R, G �� ���ÿ� 1�� ��������״� ������ �ʷ��� �ջ��� ������� �� ������.
            o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0.0);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

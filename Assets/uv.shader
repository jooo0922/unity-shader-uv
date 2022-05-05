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
            // fixed4 c = tex2D (_MainTex, IN.uv_MainTex + 0.5); // uv��ǥ�� Ư�� ���� ���ϸ�, �̹���(�� �ؽ���)�� �̵��Ѵٴ� ���� �� �� ����. -> ����Ƽ���� Wrap mode �� Repeat ���� �����ϸ� �׷���, clamp�� �����ϸ� �����ڸ� �ȼ��� �þ�� ��! -> webgl �� �� ��� ������!
            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex + _Time.y); // uv��ǥ�� ����Ƽ �ð� ���� ���庯���� _Time �� �����ְ�, Scene ���� 'Always Refresh' �� üũ�ϰų� play ��ư�� ������ �ؽ��İ� ���� �Ʒ��� �̵��ϴ� �ִϸ��̼��� �������! -> _Time ������ xyzw �� ���� ������ p.172 ���� 
            // �����, Always Refresh �� Ȱ��ȭ�ϰ�, play ��ư�� Ŭ���ϰ�, �ִϸ��̼��� ����Ƽ���� ����Ǳ⸸ �ϸ� ����Ƽ�� ���� ���ӿ��� ����� �� �ִٴ� ����!
            // fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x + _Time.y, IN.uv_MainTex.y)); // uv��ǥ�� ���������� float2 ���̹Ƿ�, uv��ǥ�� u��, �� x������ _Time �� �����ָ� x�������θ� �귯���� �� ���� ����.
            // fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x, IN.uv_MainTex.y + _Time.y)); // �̰Ŵ� v���� �����ְ� ������ y�������θ� �귯���� �ϴ� ����!
            fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x, IN.uv_MainTex.y + _Time.y * _FlowSpeed)); // �������̽����� float Ÿ���� �ӵ����� �޾ƿͼ�, _FlowSpeed ������ ������ �� _Time ���� �����ָ� �ִϸ��̼� �ӵ� ���� ����! 

            o.Albedo = c.rgb;

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
            // o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0.0);
            
            // o.Emission = float3(_CosTime.w, _SinTime.w, 0); // Sin �׷��� �� Cos �׷����� �ð����� �����ͼ� ������ R, G ���� ���� �־� �ð�ȭ�� �ִϸ��̼�
            // o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y + _SinTime.w, 0); // Sin �׷����� �ð��� (��, -1 ~ 1 ���̸� �պ��ϴ� ��)�� uv�� v���� �����ְ�, �� ���� ������ G���� �־ �ð�ȭ�� �ִϸ��̼� 
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

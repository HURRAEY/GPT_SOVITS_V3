#!/bin/bash

# GPT-SoVITS 서버 실행 스크립트
# anai-demo-view와 통합을 위한 설정

cd /Users/sjk/AnAI/GPT-SoVITS

# 가상환경 활성화
source venv/bin/activate

echo "🚀 GPT-SoVITS 서버를 시작합니다..."

# CORS 설정을 위한 환경변수
export GRADIO_SERVER_NAME="0.0.0.0"
export GRADIO_SERVER_PORT="7860"
export GRADIO_SHARE="false"

# 두 개의 서버를 백그라운드에서 실행
echo "📡 WebUI 서버 시작 중... (포트: 7860)"
python webui.py --share &
WEBUI_PID=$!

echo "⚡ API 서버 시작 중... (포트: 9880)"
python api_v2.py -a 0.0.0.0 -p 9880 &
API_PID=$!

echo "✅ 서버가 시작되었습니다!"
echo ""
echo "📊 서버 정보:"
echo "  WebUI: http://localhost:7860"
echo "  API:   http://localhost:9880"
echo ""
echo "🌐 통합 방법:"
echo "  1. iframe 통합:    integration_example.html"
echo "  2. API 커스텀:     api_integration_example.html"
echo ""
echo "⏹️  서버 종료: Ctrl+C 를 누르세요"

# 트랩을 설정하여 스크립트 종료 시 백그라운드 프로세스도 종료
trap 'echo ""; echo "🛑 서버를 종료합니다..."; kill $WEBUI_PID $API_PID 2>/dev/null; exit' INT

# 서버가 실행 중인지 확인
while kill -0 $WEBUI_PID $API_PID 2>/dev/null; do
    sleep 1
done

echo "❌ 서버가 종료되었습니다." 
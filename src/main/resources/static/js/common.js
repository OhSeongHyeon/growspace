(function() {
    const themeKey = 'daisyui-theme';
    const html = document.documentElement;
    const input = document.getElementById('themeToggleInput');

    // 1. 저장된 테마 적용 (없으면 dark)
    const savedTheme = localStorage.getItem(themeKey) || 'dark';
    html.setAttribute('data-theme', savedTheme);
    if (input) {
        input.checked = savedTheme === 'dark';

        // 2. 토글 스위치 변경시 테마 변경 & 저장
        input.addEventListener('change', function() {
            const theme = input.checked ? 'dark' : 'light';
            html.setAttribute('data-theme', theme);
            localStorage.setItem(themeKey, theme);
        });
    }

    // 3. 시스템 다크모드 감지
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
        if (!localStorage.getItem(themeKey)) {
            const theme = e.matches ? 'dark' : 'light';
            html.setAttribute('data-theme', theme);
        }
    });
})();